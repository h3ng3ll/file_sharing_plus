/// Persists the server's selected shared-folder path across restarts.
///
/// Hides the storage backend (Hive) so the rest of the feature depends only on
/// this contract.
abstract interface class ISharedFolderRepository {
  /// The persisted shared-folder path, or `null` if none was saved.
  String? read();

  /// Saves [path] as the shared folder.
  Future<void> save(String path);

  /// Clears the persisted shared folder.
  Future<void> clear();
}
