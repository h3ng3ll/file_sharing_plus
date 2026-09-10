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

  /// Verifies [server] is still reachable before the browser screen is opened.
  ///
  /// A discovered entry keeps the host and port resolved when mDNS first saw
  /// it, so it goes stale the moment the Mac's server stops or restarts on a
  /// different port. Pinging on tap turns that into a toast instead of a raw
  /// connection error on an already-pushed screen.
  const factory DiscoveryEvent.openServer(DiscoveredServer server) =
      _OpenServer;

  /// Removes [server] from the list.
  ///
  /// A manual entry is forgotten permanently. A discovered entry is only
  /// hidden until mDNS advertises it again, since discovery owns that list.
  const factory DiscoveryEvent.removeServer(DiscoveredServer server) =
      _RemoveServer;

  /// Restarts the mDNS scan, re-resolving what is currently advertised.
  const factory DiscoveryEvent.rescan() = _Rescan;

  /// Probes every listed server so each row shows a live status.
  const factory DiscoveryEvent.refreshReachability() = _RefreshReachability;

  /// Clears a consumed one-shot navigation/error signal.
  const factory DiscoveryEvent.consumeSignal() = _ConsumeSignal;
}
