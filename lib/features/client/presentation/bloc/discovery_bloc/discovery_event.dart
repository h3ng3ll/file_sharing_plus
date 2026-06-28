part of 'discovery_bloc.dart';

@freezed
sealed class DiscoveryEvent with _$DiscoveryEvent {
  /// Begins mDNS discovery.
  const factory DiscoveryEvent.start() = _Start;

  const factory DiscoveryEvent.discoveredUpdated(
    List<DiscoveredServer> servers,
  ) = _DiscoveredUpdated;

  /// Adds a manually-entered server after validating it is reachable.
  const factory DiscoveryEvent.addManual({
    required String host,
    required int port,
  }) = _AddManual;
}
