import 'dart:io';

import 'package:async/async.dart';
import 'package:file_sharing/core/models/file_entry/file_entry.dart';
import 'package:file_sharing/core/services/discovery_service.dart';
import 'package:file_sharing/features/client/data/repositories/http_client_repository.dart';
import 'package:file_sharing/features/server/data/repositories/http_server_repository.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

/// [HttpOverrides] that produces real [HttpClient]s.
///
/// `flutter_test` installs an override that makes every request return 400 so
/// unit tests never hit the network. This integration test deliberately uses a
/// real loopback socket, so it restores the default behaviour via `super`.
class _RealHttpOverrides extends HttpOverrides {}

/// Runs [body] with a real [HttpClient] available.
T _withRealHttp<T>(T Function() body) =>
    HttpOverrides.runWithHttpOverrides(body, _RealHttpOverrides());

/// End-to-end test of the HTTP transfer layer: the real server repository and
/// the real client repository talk over a loopback socket. Verifies list,
/// streamed download and streamed multipart upload.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory sharedDir;
  late Directory downloadsDir;
  late HttpServerRepository server;
  late HttpClientRepository client;
  late DiscoveredServer device;

  setUp(() async {
    sharedDir = await Directory.systemTemp.createTemp('fs_shared');
    downloadsDir = await Directory.systemTemp.createTemp('fs_downloads');

    // Stub path_provider so downloads land in a temp directory.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (call) async => downloadsDir.path,
    );
    File(p.join(sharedDir.path, 'hello.txt'))
        .writeAsStringSync('hello world');

    server = HttpServerRepository()..setSharedFolder(sharedDir.path);
    final port = await server.start(port: 0);
    // Build the client inside a real-HTTP zone so Dio's IOHttpClientAdapter
    // gets a real HttpClient instead of the flutter_test mock.
    client = _withRealHttp(HttpClientRepository.new);
    device = DiscoveredServer(
      name: 'test',
      host: InternetAddress.loopbackIPv4.address,
      port: port,
    );
  });

  tearDown(() async {
    await server.stop();
    sharedDir.deleteSync(recursive: true);
    downloadsDir.deleteSync(recursive: true);
  });

  test('ping reports the server is reachable', () {
    return _withRealHttp(() async {
      expect(
        await client.ping(host: device.host, port: device.port),
        isTrue,
      );
    });
  });

  test('listFiles returns the shared file', () {
    return _withRealHttp(() async {
      final files = await client.listFiles(server: device);
      expect(files.map((f) => f.name), contains('hello.txt'));
    });
  });

  test('download streams the file with progress', () {
    return _withRealHttp(() async {
      final updates = await client
          .downloadFile(server: device, fileName: 'hello.txt')
          .toList();
      expect(updates, isNotEmpty);
      expect(updates.last.isComplete, isTrue);
      // The final progress carries the on-disk path so the UI can offer
      // "Save to Files".
      expect(updates.last.savedPath, isNotNull);
      expect(File(updates.last.savedPath!).existsSync(), isTrue);
    });
  });

  test('upload streams a multipart file to the shared folder', () {
    return _withRealHttp(() async {
      final src = File(p.join(sharedDir.path, 'to_upload.bin'));
      src.writeAsBytesSync(List<int>.generate(50000, (i) => i % 256));

      final updates = await client
          .uploadFile(server: device, filePath: src.path)
          .toList();
      expect(updates.last.transferred, updates.last.total);

      final uploaded = File(p.join(sharedDir.path, 'to_upload.bin'));
      expect(uploaded.existsSync(), isTrue);
      expect(uploaded.lengthSync(), 50000);
    });
  });

  test('listFiles tolerates symlinks in the shared folder', () {
    return _withRealHttp(() async {
      // A symlink lists as a Link (not File/Directory); listing must not throw.
      Link(p.join(sharedDir.path, 'shortcut'))
          .createSync(p.join(sharedDir.path, 'hello.txt'));

      final result = await client.listFiles(server: device);
      final names = result.map((f) => f.name);
      expect(names, contains('hello.txt'));
      expect(names, contains('shortcut'));
    });
  });

  test('watchFiles pushes listings over the WebSocket on change', () {
    return _withRealHttp(() async {
      final watch = client.watchFiles(server: device);
      // Buffer pushes; the stream is broadcast, so subscribe before watching.
      final events = StreamQueue<List<FileEntry>>(watch.files);

      watch.watch('');

      // 1) Initial listing after the watch request.
      final initial = await events.next.timeout(const Duration(seconds: 5));
      expect(initial.map((f) => f.name), contains('hello.txt'));

      // 2) Creating a new file pushes an updated listing — no GET /files call.
      File(p.join(sharedDir.path, 'live.txt')).writeAsStringSync('new');
      final afterCreate = await _nextContaining(
        events,
        'live.txt',
      ).timeout(const Duration(seconds: 5));
      expect(afterCreate.map((f) => f.name), contains('live.txt'));

      // 3) Switching the shared folder pushes the new folder's contents.
      final otherDir = await Directory.systemTemp.createTemp('fs_other');
      File(p.join(otherDir.path, 'other.txt')).writeAsStringSync('x');
      server.setSharedFolder(otherDir.path);
      final afterSwitch = await _nextContaining(
        events,
        'other.txt',
      ).timeout(const Duration(seconds: 5));
      expect(afterSwitch.map((f) => f.name), contains('other.txt'));
      expect(afterSwitch.map((f) => f.name), isNot(contains('hello.txt')));

      await events.cancel();
      await watch.close();
      otherDir.deleteSync(recursive: true);
    });
  });
}

/// Pulls listings from [events] until one containing [name] arrives.
Future<List<FileEntry>> _nextContaining(
  StreamQueue<List<FileEntry>> events,
  String name,
) async {
  while (true) {
    final files = await events.next;
    if (files.any((f) => f.name == name)) return files;
  }
}
