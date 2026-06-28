import 'dart:io';

import '../../../../core/services/discovery_service.dart';
import '../../../../core/services/network_info_service.dart';
import '../repositories/i_server_repository.dart';

/// Result of a successful server start.
class StartServerResult {
  final int port;
  final String? ipAddress;

  const StartServerResult({
    required this.port,
    required this.ipAddress,
  });
}

/// Orchestrates starting the HTTP server and advertising it over Bonjour.
class StartServerUseCase {
  final IServerRepository _serverRepository;
  final DiscoveryService _discoveryService;
  final NetworkInfoService _networkInfoService;

  const StartServerUseCase({
    required IServerRepository serverRepository,
    required DiscoveryService discoveryService,
    required NetworkInfoService networkInfoService,
  })  : _serverRepository = serverRepository,
        _discoveryService = discoveryService,
        _networkInfoService = networkInfoService;

  /// Starts the server and registers the Bonjour service.
  Future<StartServerResult> call({int port = 8080}) async {
    final boundPort = await _serverRepository.start(port: port);
    final ip = await _networkInfoService.getLocalIpAddress();

    await _discoveryService.registerServer(
      name: '${Platform.localHostname} File Sharing',
      port: boundPort,
    );

    return StartServerResult(
      port: boundPort,
      ipAddress: ip,
    );
  }
}
