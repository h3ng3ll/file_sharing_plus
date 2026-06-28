import '../repositories/i_server_settings_repository.dart';

/// Reads and persists the server's sharing port.
class PersistPortUseCase {
  final IServerSettingsRepository _serverSettingsRepository;

  const PersistPortUseCase({
    required IServerSettingsRepository serverSettingsRepository,
  }) : _serverSettingsRepository = serverSettingsRepository;

  /// The previously saved port, or `null`.
  int? read() => _serverSettingsRepository.readPort();

  /// Persists [port] as the sharing port.
  Future<void> save(int port) => _serverSettingsRepository.savePort(port);
}
