/// Persists the server's settings (e.g. the sharing port) across restarts.
///
/// Hides the storage backend (Hive) so the rest of the feature depends only on
/// this contract.
abstract interface class IServerSettingsRepository {
  /// The persisted sharing port, or `null` if none was saved.
  int? readPort();

  /// Saves [port] as the sharing port.
  Future<void> savePort(int port);
}
