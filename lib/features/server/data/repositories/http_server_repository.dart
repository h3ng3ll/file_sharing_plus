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
  }

  @override
  Future<int> start({int port = 8080}) async {
    await stop();
    final server = await HttpServer.bind(InternetAddress.anyIPv4, port);
    _server = server;
    _log(ActivityType.serverStarted, 'Server started on port ${server.port}');

    unawaited(server.forEach(_handleRequest));
    return server.port;
  }

  @override
  Future<void> stop() async {
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
      if (request.method == 'GET' && path == '/ping') {
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
    final root = _sharedFolder;
    if (root == null) {
      _writeJson(request.response, {'files': <dynamic>[]});
      await request.response.close();
      return;
    }

    final relative = request.uri.queryParameters['path'] ?? '';
    final dir = Directory(_safeJoin(root, relative));
    if (!dir.existsSync()) {
      request.response.statusCode = HttpStatus.notFound;
      await request.response.close();
      return;
    }

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

    _writeJson(request.response, {
      'files': entries.map((e) => e.toJson()).toList(),
    });
    await request.response.close();
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
