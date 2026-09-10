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

  /// How long a device with no open event stream stays listed after its last
  /// request. HTTP is stateless, so an idle client is only distinguishable
  /// from a departed one by elapsed time.
  static const Duration _kDeviceIdleTimeout = Duration(seconds: 30);

  /// How often idle devices are swept out of the list.
  static const Duration _kDeviceSweepInterval = Duration(seconds: 5);

  /// Connected event sockets, each tracking the folder path it is watching.
  final _sockets = <WebSocket, String>{};

  /// Remote address behind each event socket, so a closing socket can mark
  /// the right device disconnected.
  final _socketAddresses = <WebSocket, String>{};

  /// Drops devices that stopped making requests and hold no event stream.
  Timer? _deviceSweep;

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
    // Idle devices must age out even when no further request arrives.
    _deviceSweep = Timer.periodic(
      _kDeviceSweepInterval,
      (_) => _refreshDevicePresence(),
    );
    return server.port;
  }

  @override
  Future<void> stop() async {
    await _folderWatch?.cancel();
    _folderWatch = null;
    _watchDebounce?.cancel();
    _watchDebounce = null;

    _deviceSweep?.cancel();
    _deviceSweep = null;

    for (final socket in _sockets.keys.toList()) {
      await socket.close();
    }
    _sockets.clear();
    _socketAddresses.clear();

    // Devices are per-session: drop them and publish the cleared list so a
    // restart never resurrects the previous session's clients.
    _devices.clear();
    _devicesController.add(const <ConnectedDevice>[]);

    final server = _server;
    if (server != null) {
      await server.close(force: true);
      _server = null;
      _log(ActivityType.serverStopped, 'Server stopped');
    }
  }

  Future<void> _handleRequest(HttpRequest request) async {
    try {
      final path = request.uri.path;
      if (request.method == 'GET' && path == '/events') {
        await _handleEvents(request);
      } else if (request.method == 'GET' && path == '/ping') {
        await _handlePing(request);
      } else if (request.method == 'GET' && path == '/files') {
        await _handleListFiles(request);
      } else if (request.method == 'GET' && path == '/download') {
        await _handleDownload(request);
      } else if (request.method == 'DELETE' && path == '/delete') {
        await _handleDelete(request);
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
    _trackDevice(request);
    _writeJson(request.response, {
      'status': 'ok',
      'name': Platform.localHostname,
    });
    await request.response.close();
  }

  Future<void> _handleListFiles(HttpRequest request) async {
    _trackDevice(request);
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
      entries.add(
        FileEntry(
          name: p.basename(entity.path),
          isDirectory: entity is Directory,
          size: _entrySize(entity),
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

  /// Size in bytes for a directory entry. Returns 0 for directories, symlinks
  /// ([Link]) and any entry whose length cannot be read.
  int _entrySize(FileSystemEntity entity) {
    if (entity is! File) return 0;
    try {
      return entity.lengthSync();
    } catch (_) {
      return 0;
    }
  }

  Future<void> _handleDownload(HttpRequest request) async {
    _trackDevice(request);
    final root = _sharedFolder;
    if (root == null) {
      request.response.statusCode = HttpStatus.notFound;
      await request.response.close();
      return;
    }

    final relative = request.uri.queryParameters['path'] ?? '';
    final file = File(_safeJoin(root, relative));
    if (relative.isEmpty || !file.existsSync()) {
      request.response.statusCode = HttpStatus.notFound;
      await request.response.close();
      return;
    }

    final length = file.lengthSync();
    final name = p.basename(file.path);
    request.response.statusCode = HttpStatus.ok;
    request.response.headers
      ..contentType = ContentType.binary
      ..contentLength = length
      ..add(
        HttpHeaders.contentDisposition,
        _contentDisposition(name),
      );

    // Stream the file straight to the socket; never load it into memory.
    await request.response.addStream(file.openRead());
    await request.response.close();
    _log(ActivityType.download, 'Downloaded ${p.basename(file.path)}');
  }

  Future<void> _handleUpload(HttpRequest request) async {
    _trackDevice(request);
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

  Future<void> _handleDelete(HttpRequest request) async {
    _trackDevice(request);
    final root = _sharedFolder;
    if (root == null) {
      request.response.statusCode = HttpStatus.serviceUnavailable;
      await request.response.close();
      return;
    }

    final relative = request.uri.queryParameters['path'] ?? '';
    if (relative.isEmpty) {
      request.response.statusCode = HttpStatus.badRequest;
      await request.response.close();
      return;
    }
    final target = _safeJoin(root, relative);
    final type = FileSystemEntity.typeSync(target, followLinks: false);

    if (type == FileSystemEntityType.notFound) {
      request.response.statusCode = HttpStatus.notFound;
      await request.response.close();
      return;
    }
    // Files only — deleting directories is not supported.
    if (type == FileSystemEntityType.directory) {
      request.response.statusCode = HttpStatus.forbidden;
      await request.response.close();
      return;
    }

    File(target).deleteSync();
    _writeJson(request.response, {'status': 'ok'});
    await request.response.close();
    _log(ActivityType.delete, 'Deleted ${p.basename(target)}');
    // Reflect the removal to browsing clients immediately.
    _pushToAllSockets();
  }

  /// Upgrades the request to a WebSocket and streams folder listings to the
  /// client. The client sends `{"type":"watch","path":"<relative>"}`; the
  /// server replies with the listing for that path and re-pushes it on change.
  Future<void> _handleEvents(HttpRequest request) async {
    // Only a completed upgrade is a real connection: a browser opening this
    // path with a plain GET throws above this line and must not be tracked.
    final socket = await WebSocketTransformer.upgrade(request);
    final address = request.connectionInfo?.remoteAddress.address;
    _trackDevice(request);
    _sockets[socket] = '';
    if (address != null) _socketAddresses[socket] = address;
    _refreshDevicePresence();
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
      onDone: () => _releaseSocket(socket),
      onError: (_) => _releaseSocket(socket),
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

  /// Builds a `Content-Disposition` value that survives non-ASCII names.
  ///
  /// `dart:io` HTTP headers are Latin-1, so a raw Unicode filename throws.
  /// We emit an ASCII-only `filename=` fallback plus an RFC 5987
  /// `filename*=UTF-8''…` with the real (percent-encoded) name.
  String _contentDisposition(String name) {
    final asciiFallback = name.replaceAll(RegExp(r'[^\x20-\x7E]|["\\]'), '_');
    final encoded = Uri.encodeComponent(name);
    return 'attachment; filename="$asciiFallback"; '
        "filename*=UTF-8''$encoded";
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
      hasOpenEventStream: _socketAddresses.values.contains(address),
    );
    _devicesController.add(_devices.values.toList());
    if (isNew) {
      _log(ActivityType.connection, 'Device connected: $address');
    }
  }

  /// Forgets [socket] and marks its device disconnected if it held the last
  /// event stream for that address.
  void _releaseSocket(WebSocket socket) {
    _sockets.remove(socket);
    _socketAddresses.remove(socket);
    _refreshDevicePresence();
  }

  /// Re-derives [ConnectedDevice.hasOpenEventStream] from the live socket set
  /// and drops devices that are neither streaming nor recently active.
  void _refreshDevicePresence() {
    final streaming = _socketAddresses.values.toSet();
    final now = DateTime.now();
    var changed = false;

    for (final address in _devices.keys.toList()) {
      final device = _devices[address]!;
      final isStreaming = streaming.contains(address);
      final isIdle = now.difference(device.lastSeen) > _kDeviceIdleTimeout;

      // A device with no event stream that has also stopped making requests
      // has left: nothing else can tell us, so time is the only evidence.
      if (!isStreaming && isIdle) {
        _devices.remove(address);
        _log(ActivityType.connection, 'Device disconnected: $address');
        changed = true;
        continue;
      }

      if (device.hasOpenEventStream != isStreaming) {
        _devices[address] = device.copyWith(hasOpenEventStream: isStreaming);
        if (!isStreaming) {
          _log(ActivityType.connection, 'Event stream closed: $address');
        }
        changed = true;
      }
    }

    if (changed) _devicesController.add(_devices.values.toList());
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
