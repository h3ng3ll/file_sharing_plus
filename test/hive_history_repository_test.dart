import 'dart:io';

import 'package:file_sharing/core/hive/hive_registrar.g.dart';
import 'package:file_sharing/features/client/data/repositories/hive_history_repository.dart';
import 'package:file_sharing/features/client/domain/models/transfer_progress.dart';
import 'package:file_sharing/features/client/domain/models/transfer_record.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';

/// Verifies the Hive-backed history repository persists records and streams
/// updates. Uses a temp directory so it never touches real app storage.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory dir;
  late Box<TransferRecord> box;
  late HiveHistoryRepository repository;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('fs_hive');
    Hive.init(dir.path);
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapters();
    }
    box = await Hive.openBox<TransferRecord>('test_history');
    repository = HiveHistoryRepository(box: box);
  });

  tearDown(() async {
    await box.close();
    await Hive.close();
    dir.deleteSync(recursive: true);
  });

  TransferRecord record(String name) => TransferRecord(
        fileName: name,
        direction: TransferDirection.download,
        success: true,
        timestamp: DateTime(2026, 1, 1),
      );

  test('add then getAll returns newest first', () async {
    await repository.add(record('a.txt'));
    await repository.add(record('b.txt'));

    final all = repository.getAll();
    expect(all.map((r) => r.fileName), ['b.txt', 'a.txt']);
  });

  test('watch emits the current list and updates on add', () async {
    final emissions = <List<TransferRecord>>[];
    final sub = repository.watch().listen(emissions.add);

    // Initial seed.
    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect(emissions.first, isEmpty);

    await repository.add(record('c.txt'));
    await Future<void>.delayed(const Duration(milliseconds: 10));

    expect(emissions.last.map((r) => r.fileName), contains('c.txt'));
    await sub.cancel();
  });

  test('records persist across reopening the box', () async {
    await repository.add(record('persist.txt'));
    await box.close();

    box = await Hive.openBox<TransferRecord>('test_history');
    final reopened = HiveHistoryRepository(box: box);
    expect(reopened.getAll().map((r) => r.fileName), contains('persist.txt'));
  });
}
