import 'package:hive_ce/hive.dart';

import '../../domain/models/shared_folder.dart';
import '../../domain/repositories/i_shared_folder_repository.dart';

/// Hive-backed [ISharedFolderRepository].
///
/// Stores a single record under [_key], overwritten whenever the user picks a
/// new folder. The opened box is injected, so the repository owns no Hive
/// setup/teardown.
class HiveSharedFolderRepository implements ISharedFolderRepository {
  final Box<SharedFolder> _box;

  HiveSharedFolderRepository({required Box<SharedFolder> box}) : _box = box;

  static const String _key = 'current';

  @override
  String? read() => _box.get(_key)?.path;

  @override
  Future<void> save(String path) =>
      _box.put(_key, SharedFolder(path: path));

  @override
  Future<void> clear() => _box.delete(_key);
}
