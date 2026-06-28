import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../../core/models/file_entry/file_entry.dart';
import '../../../../core/services/discovery_service.dart';
import '../../domain/models/transfer_progress.dart';
import '../../domain/repositories/folder_watch.dart';
import '../../domain/repositories/i_client_repository.dart';

/// [Dio]-backed implementation of [IClientRepository].
///
/// Downloads use a streamed response piped straight into [File.openWrite];
/// uploads use a [MultipartFile] sourced from disk. Neither buffers the whole
/// file, so large transfers work and progress is reported continuously via
/// Dio's `onReceiveProgress` / `onSendProgress` callbacks.
class HttpClientRepository implements IClientRepository {
  final Dio _dio;

  HttpClientRepository({Dio? dio}) : _dio = dio ?? Dio();

  String _baseUrl(DiscoveredServer server) =>
      'http://${server.host}:${server.port}';

  @override
  Future<bool> ping({required String host, required int port}) async {
    try {
      final response = await _dio.get<dynamic>(
        'http://$host:$port/ping',
        options: Options(
          sendTimeout: const Duration(seconds: 3),
          receiveTimeout: const Duration(seconds: 3),
        ),
      );
      return response.statusCode == HttpStatus.ok;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<List<FileEntry>> listFiles({
    required DiscoveredServer server,
    String path = '',
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '${_baseUrl(server)}/files',
      queryParameters: path.isEmpty ? null : {'path': path},
    );
    final data = response.data ?? const {'files': <dynamic>[]};
    final files = (data['files'] as List<dynamic>)
        .map((e) => FileEntry.fromJson(e as Map<String, dynamic>))
        .toList();
    return files;
  }

  @override
  Stream<TransferProgress> downloadFile({
    required DiscoveredServer server,
    required String fileName,
    String path = '',
  }) async* {
    final relative = path.isEmpty ? fileName : p.join(path, fileName);
    final controller = StreamController<TransferProgress>();

    Future<void> run() async {
      IOSink? sink;
      try {
        final response = await _dio.get<ResponseBody>(
          '${_baseUrl(server)}/download',
          queryParameters: {'path': relative},
          options: Options(responseType: ResponseType.stream),
        );

        final total = response.data?.contentLength ?? -1;
        final dir = await getApplicationDocumentsDirectory();
        final dest = File(p.join(dir.path, fileName));
        sink = dest.openWrite();
        var received = 0;

        await for (final chunk in response.data!.stream) {
          sink.add(chunk);
          received += chunk.length;
          controller.add(
            TransferProgress(
              fileName: fileName,
              direction: TransferDirection.download,
              transferred: received,
              total: total,
            ),
          );
        }
        await sink.flush();

        controller.add(
          TransferProgress(
            fileName: fileName,
            direction: TransferDirection.download,
            transferred: received,
            total: total <= 0 ? received : total,
            savedPath: dest.path,
          ),
        );
        await controller.close();
      } catch (e, s) {
        controller.addError(e, s);
        await controller.close();
      } finally {
        await sink?.close();
      }
    }

    unawaited(run());
    yield* controller.stream;
  }

  @override
  Stream<TransferProgress> uploadFile({
    required DiscoveredServer server,
    required String filePath,
  }) async* {
    final fileName = p.basename(filePath);
    final controller = StreamController<TransferProgress>();

    Future<void> run() async {
      try {
        // MultipartFile.fromFile streams the file from disk rather than
        // loading it into memory.
        final formData = FormData.fromMap({
          'file': await MultipartFile.fromFile(filePath, filename: fileName),
        });

        await _dio.post<dynamic>(
          '${_baseUrl(server)}/upload',
          data: formData,
          onSendProgress: (sent, total) {
            controller.add(
              TransferProgress(
                fileName: fileName,
                direction: TransferDirection.upload,
                transferred: sent,
                total: total,
              ),
            );
          },
        );
        await controller.close();
      } catch (e, s) {
        controller.addError(e, s);
        await controller.close();
      }
    }

    unawaited(run());
    yield* controller.stream;
  }

  @override
  FolderWatch watchFiles({required DiscoveredServer server}) {
    return _WebSocketFolderWatch(
      url: 'ws://${server.host}:${server.port}/events',
    );
  }

  @override
  Future<void> deleteFile({
    required DiscoveredServer server,
    required String fileName,
    String path = '',
  }) async {
    final relative = path.isEmpty ? fileName : p.join(path, fileName);
    await _dio.delete<dynamic>(
      '${_baseUrl(server)}/delete',
      queryParameters: {'path': relative},
    );
  }
}

/// [FolderWatch] backed by a `dart:io` [WebSocket] to the server's `/events`
/// endpoint.
///
/// Connects lazily on the first [watch] call, sends the watched path, and
/// emits a [FileEntry] list for every matching `files` message the server
/// pushes. Filters out messages for other paths so a pending navigation never
/// shows the wrong folder.
class _WebSocketFolderWatch implements FolderWatch {
  final String url;
  final _controller = StreamController<List<FileEntry>>.broadcast();

  WebSocket? _socket;
  Future<void>? _connecting;
  String _path = '';
  bool _closed = false;

  _WebSocketFolderWatch({required this.url});

  @override
  Stream<List<FileEntry>> get files => _controller.stream;

  @override
  void watch(String path) {
    _path = path;
    final socket = _socket;
    if (socket != null && socket.readyState == WebSocket.open) {
      _send(socket);
    } else {
      _connecting ??= _connect();
    }
  }

  Future<void> _connect() async {
    try {
      final socket = await WebSocket.connect(url);
      if (_closed) {
        await socket.close();
        return;
      }
      _socket = socket;
      socket.listen(
        _onMessage,
        onDone: () => _socket = null,
        onError: (Object e, StackTrace s) {
          if (!_controller.isClosed) _controller.addError(e, s);
        },
        cancelOnError: true,
      );
      _send(socket);
    } catch (e, s) {
      if (!_controller.isClosed) _controller.addError(e, s);
    }
  }

  void _send(WebSocket socket) {
    socket.add(jsonEncode({'type': 'watch', 'path': _path}));
  }

  void _onMessage(dynamic message) {
    try {
      final decoded = jsonDecode(message as String) as Map<String, dynamic>;
      if (decoded['type'] != 'files') return;
      // Ignore listings for a path we are no longer viewing.
      if ((decoded['path'] as String?) != _path) return;
      final files = (decoded['files'] as List<dynamic>)
          .map((e) => FileEntry.fromJson(e as Map<String, dynamic>))
          .toList();
      if (!_controller.isClosed) _controller.add(files);
    } catch (_) {
      // Ignore malformed server messages.
    }
  }

  @override
  Future<void> close() async {
    _closed = true;
    await _socket?.close();
    _socket = null;
    await _controller.close();
  }
}
