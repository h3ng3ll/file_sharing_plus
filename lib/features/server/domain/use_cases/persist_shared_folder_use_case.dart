import '../repositories/i_shared_folder_repository.dart';

/// Reads and persists the server's shared-folder selection.
class PersistSharedFolderUseCase {
  final ISharedFolderRepository _sharedFolderRepository;

  const PersistSharedFolderUseCase({
    required ISharedFolderRepository sharedFolderRepository,
  }) : _sharedFolderRepository = sharedFolderRepository;

  /// The previously saved folder path, or `null`.
  String? read() => _sharedFolderRepository.read();

  /// Persists [path] as the shared folder.
  Future<void> save(String path) => _sharedFolderRepository.save(path);
}
