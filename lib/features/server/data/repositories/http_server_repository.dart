import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

import '../../../../core/models/file_entry/file_entry.dart';
import '../../domain/models/activity_log_entry.dart';
import '../../domain/models/connected_device.dart';
import '../../domain/repositories/i_server_repository.dart';
import '../parsing/multipart_parser.dart';

/// `dart:io` [HttpServer]-backed implementation of [IServerRepository].
///
/// All file I/O is streamed: downloads use [File.openRead] piped into the
/// response, and uploads pipe the request body straight into [File.openWrite].
/// Nothing is buffered fully in memory, so arbitrarily large files work.
class HttpServerRepository implements IServerRepository {
  HttpServer? _server;
  String? _sharedFolder;

  /// Connected event sockets, each tracking the folder path it is watching.
  final _sockets = <WebSocket, String>{};

  /// Active filesystem watch on the shared folder, if any.
  StreamSubscription<FileSystemEvent>? _folderWatch;

  /// Coalesces bursts of filesystem events into a single push.
  Timer? _watchDebounce;

  final _devices = <String, ConnectedDevice>{};
  final _devicesController =
      StreamController<List<ConnectedDevice>>.broadcast();
  final _logController = StreamController<ActivityLogEntry>.broadcast();

  @override
  Stream<List<ConnectedDevice>> get connectedDevices =>
      _devicesController.stream;

  @override
  Stream<ActivityLogEntry> get activityLog => _logController.stream;

  @override
  void setSharedFolder(String path) {
    _sharedFolder = path;
    // Re-target the filesystem watch and push fresh listings to every client
    // so a folder change on the Mac is reflected immediately.
    _startFolderWatch();
    _pushToAllSockets();
  }

  @override
  Future<int> start({int port = 8080}) async {
    await stop();
    final server = await HttpServer.bind(InternetAddress.anyIPv4, port);
    _server = server;
    _log(ActivityType.serverStarted, 'Server started on port ${server.port}');

    unawaited(server.forEach(_handleRequest));
    _startFolderWatch();
    return server.port;
  }

  @override
  Future<void> stop() async {
    await _folderWatch?.cancel();
    _folderWatch = null;
    _watchDebounce?.cancel();
    _watchDebounce = null;

    for (final socket in _sockets.keys.toList()) {
      await socket.close();
    }
    _sockets.clear();

    final server = _server;
    if (server != null) {
      await server.close(force: true);
      _server = null;
      _log(ActivityType.serverStopped, 'Server stopped');
    }
  }

  Future<void> _handleRequest(HttpRequest request) async {
    _trackDevice(request);
    try {
      final path = request.uri.path;
      if (request.method == 'GET' && path == '/events') {
        await _handleEvents(request);
      } else if (request.method == 'GET' && path == '/ping') {
        await _handlePing(request);
      } else if (request.method == 'GET' && path == '/files') {
        await _handleListFiles(request);
      } else if (request.method == 'GET' && path.startsWith('/download/')) {
        await _handleDownload(request);
      } else if (request.method == 'POST' && path == '/upload') {
        await _handleUpload(request);
      } else {
        request.response.statusCode = HttpStatus.notFound;
        await request.response.close();
      }
    } catch (e) {
      _log(ActivityType.error, 'Request failed: $e');
      try {
        request.response.statusCode = HttpStatus.internalServerError;
        await request.response.close();
      } catch (_) {
        // Response already committed; nothing more to do.
      }
    }
  }

  Future<void> _handlePing(HttpRequest request) async {
    _writeJson(request.response, {
      'status': 'ok',
      'name': Platform.localHostname,
    });
    await request.response.close();
  }

  Future<void> _handleListFiles(HttpRequest request) async {
    final relative = request.uri.queryParameters['path'] ?? '';
    final entries = await _scanFolder(relative);
    if (entries == null) {
      request.response.statusCode = HttpStatus.notFound;
      await request.response.close();
      return;
    }

    _writeJson(request.response, {
      'files': entries.map((e) => e.toJson()).toList(),
    });
    await request.response.close();
  }

  /// Lists the shared folder's contents at [relative], sorted folders-first
  /// then alphabetically. Returns an empty list when no folder is shared, or
  /// `null` when the requested path does not exist.
  ///
  /// Single source of truth for the listing exposed by both `GET /files` and
  /// the WebSocket event stream.
  Future<List<FileEntry>?> _scanFolder(String relative) async {
    final root = _sharedFolder;
    if (root == null) return const <FileEntry>[];

    final dir = Directory(_safeJoin(root, relative));
    if (!dir.existsSync()) return null;

    final entries = <FileEntry>[];
    await for (final entity in dir.list(followLinks: false)) {
      final isDir = entity is Directory;
      entries.add(
        FileEntry(
          name: p.basename(entity.path),
          isDirectory: isDir,
          size: isDir ? 0 : (entity as File).lengthSync(),
        ),
      );
    }
    entries.sort((a, b) {
      if (a.isDirectory != b.isDirectory) {
        return a.isDirectory ? -1 : 1;
      }
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
    return entries;
  }

  Future<void> _handleDownload(HttpRequest request) async {
    final root = _sharedFolder;
    if (root == null) {
      request.response.statusCode = HttpStatus.notFound;
      await request.response.close();
      return;
    }

    final relative =
        Uri.decodeComponent(request.uri.path.substring('/download/'.length));
    final file = File(_safeJoin(root, relative));
    if (!file.existsSync()) {
      request.response.statusCode = HttpStatus.notFound;
      await request.response.close();
      return;
    }

    final length = file.lengthSync();
    request.response.statusCode = HttpStatus.ok;
    request.response.headers
      ..contentType = ContentType.binary
      ..contentLength = length
      ..add(
        HttpHeaders.contentDisposition,
        'attachment; filename="${p.basename(file.path)}"',
      );

    // Stream the file straight to the socket; never load it into memory.
    await request.response.addStream(file.openRead());
    await request.response.close();
    _log(ActivityType.download, 'Downloaded ${p.basename(file.path)}');
  }

  Future<void> _handleUpload(HttpRequest request) async {
    final root = _sharedFolder;
    if (root == null) {
      request.response.statusCode = HttpStatus.serviceUnavailable;
      await request.response.close();
      return;
    }

    final contentType = request.headers.contentType;
    final boundary = contentType?.parameters['boundary'];
    if (contentType?.mimeType != 'multipart/form-data' || boundary == null) {
      request.response.statusCode = HttpStatus.badRequest;
      await request.response.close();
      return;
    }

    final fileName = await MultipartParser.streamFileToDisk(
      request: request,
      boundary: boundary,
      destinationResolver: (name) => _safeJoin(root, name),
    );

    if (fileName == null) {
      request.response.statusCode = HttpStatus.badRequest;
      await request.response.close();
      return;
    }

    _writeJson(request.response, {'status': 'ok', 'name': fileName});
    await request.response.close();
    _log(ActivityType.upload, 'Received $fileName');
    // Reflect the new file to browsing clients immediately, without waiting for
    // the filesystem watch to fire.
    _pushToAllSockets();
  }

  /// Upgrades the request to a WebSocket and streams folder listings to the
  /// client. The client sends `{"type":"watch","path":"<relative>"}`; the
  /// server replies with the listing for that path and re-pushes it on change.
  Future<void> _handleEvents(HttpRequest request) async {
    final socket = await WebSocketTransformer.upgrade(request);
    _sockets[socket] = '';
    _log(ActivityType.connection, 'Event stream opened');

    socket.listen(
      (dynamic message) async {
        try {
          final decoded = jsonDecode(message as String) as Map<String, dynamic>;
          if (decoded['type'] == 'watch') {
            final path = (decoded['path'] as String?) ?? '';
            _sockets[socket] = path;
            await _pushToSocket(socket, path);
          }
        } catch (_) {
          // Ignore malformed client messages.
        }
      },
      onDone: () => _sockets.remove(socket),
      onError: (_) => _sockets.remove(socket),
      cancelOnError: true,
    );
  }

  /// (Re)starts the recursive filesystem watch on the shared folder.
  void _startFolderWatch() {
    _folderWatch?.cancel();
    _folderWatch = null;

    final root = _sharedFolder;
    if (root == null) return;
    final dir = Directory(root);
    if (!dir.existsSync()) return;

    _folderWatch = dir.watch(recursive: true).listen(
      (_) => _scheduleWatchPush(),
      onError: (_) {},
    );
  }

  /// Debounces filesystem events so a burst results in a single push.
  void _scheduleWatchPush() {
    _watchDebounce?.cancel();
    _watchDebounce = Timer(
      const Duration(milliseconds: 250),
      _pushToAllSockets,
    );
  }

  /// Pushes the current listing to every connected socket, each for the path
  /// it is watching.
  void _pushToAllSockets() {
    for (final entry in _sockets.entries) {
      unawaited(_pushToSocket(entry.key, entry.value));
    }
  }

  /// Sends the listing for [path] to a single [socket].
  Future<void> _pushToSocket(WebSocket socket, String path) async {
    if (socket.readyState != WebSocket.open) return;
    try {
      final entries = await _scanFolder(path);
      socket.add(
        jsonEncode({
          'type': 'files',
          'path': path,
          'files': (entries ?? const <FileEntry>[])
              .map((e) => e.toJson())
              .toList(),
        }),
      );
    } catch (_) {
      // Path no longer valid or socket closed mid-write; ignore.
    }
  }

  /// Joins [relative] onto [root], rejecting any path that escapes [root].
  String _safeJoin(String root, String relative) {
    final normalizedRoot = p.normalize(p.absolute(root));
    final candidate = p.normalize(p.join(normalizedRoot, relative));
    if (!p.isWithin(normalizedRoot, candidate) &&
        candidate != normalizedRoot) {
      throw const FileSystemException('Path escapes shared folder');
    }
    return candidate;
  }

  void _trackDevice(HttpRequest request) {
    final address = request.connectionInfo?.remoteAddress.address;
    if (address == null) return;

    final existing = _devices[address];
    final isNew = existing == null;
    _devices[address] = ConnectedDevice(
      address: address,
      lastSeen: DateTime.now(),
      requestCount: (existing?.requestCount ?? 0) + 1,
    );
    _devicesController.add(_devices.values.toList());
    if (isNew) {
      _log(ActivityType.connection, 'Device connected: $address');
    }
  }

  void _writeJson(HttpResponse response, Map<String, dynamic> body) {
    response.headers.contentType = ContentType.json;
    response.write(jsonEncode(body));
  }

  void _log(ActivityType type, String message) {
    _logController.add(
      ActivityLogEntry(
        type: type,
        message: message,
        timestamp: DateTime.now(),
      ),
    );
  }
}
