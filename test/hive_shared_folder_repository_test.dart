import 'dart:io';

import 'package:file_sharing/core/hive/hive_registrar.g.dart';
import 'package:file_sharing/features/server/data/repositories/hive_shared_folder_repository.dart';
import 'package:file_sharing/features/server/domain/models/shared_folder.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';

/// Verifies the Hive-backed shared-folder repository persists the selected
/// path. Uses a temp directory so it never touches real app storage.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory dir;
  late Box<SharedFolder> box;
  late HiveSharedFolderRepository repository;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('fs_shared_folder');
    Hive.init(dir.path);
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapters();
    }
    box = await Hive.openBox<SharedFolder>('test_shared_folder');
    repository = HiveSharedFolderRepository(box: box);
  });

  tearDown(() async {
    await box.close();
    await Hive.close();
    dir.deleteSync(recursive: true);
  });

  test('save then read returns the path', () async {
    expect(repository.read(), isNull);
    await repository.save('/Users/me/Shared');
    expect(repository.read(), '/Users/me/Shared');
  });

  test('save overwrites the previous path', () async {
    await repository.save('/a');
    await repository.save('/b');
    expect(repository.read(), '/b');
  });

  test('path persists across reopening the box', () async {
    await repository.save('/persisted');
    await box.close();

    box = await Hive.openBox<SharedFolder>('test_shared_folder');
    final reopened = HiveSharedFolderRepository(box: box);
    expect(reopened.read(), '/persisted');
  });

  test('clear removes the saved path', () async {
    await repository.save('/x');
    await repository.clear();
    expect(repository.read(), isNull);
  });
}
