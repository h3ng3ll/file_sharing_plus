import '../../../../core/services/discovery_service.dart';

/// Starts mDNS discovery and exposes the live server list.
class DiscoverServersUseCase {
  final DiscoveryService _discoveryService;

  const DiscoverServersUseCase({
    required DiscoveryService discoveryService,
  }) : _discoveryService = discoveryService;

  /// Live stream of discovered servers.
  Stream<List<DiscoveredServer>> get servers => _discoveryService.servers;

  /// Begins browsing for servers on the local network.
  Future<void> start() => _discoveryService.startDiscovery();

  /// Stops browsing.
  Future<void> stop() => _discoveryService.stopDiscovery();
}
