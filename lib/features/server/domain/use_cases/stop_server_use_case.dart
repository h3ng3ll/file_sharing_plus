import '../../../../core/services/discovery_service.dart';
import '../repositories/i_server_repository.dart';

/// Orchestrates stopping the HTTP server and withdrawing the Bonjour service.
class StopServerUseCase {
  final IServerRepository _serverRepository;
  final DiscoveryService _discoveryService;

  const StopServerUseCase({
    required IServerRepository serverRepository,
    required DiscoveryService discoveryService,
  })  : _serverRepository = serverRepository,
        _discoveryService = discoveryService;

  Future<void> call() async {
    await _discoveryService.unregisterServer();
    await _serverRepository.stop();
  }
}
