part of 'discovery_bloc.dart';

enum DiscoveryStatus {
  initial,
  discovering,
  validatingManual,
  checkingServer,
  failure,
}

/// Whether a listed server has been confirmed reachable.
///
/// mDNS keeps advertising a service for a while after the Mac's server stops,
/// so being in the list is not evidence the server is up.
enum ServerReachability {
  unknown,
  checking,
  online,
  offline,
}

extension DiscoveryStateX on DiscoveryState {
  bool get isDiscovering => status == DiscoveryStatus.discovering;
  bool get isValidatingManual => status == DiscoveryStatus.validatingManual;
  bool get isCheckingServer => status == DiscoveryStatus.checkingServer;
  bool get isFailure => status == DiscoveryStatus.failure;

  /// Reachability of [server] as last probed.
  ServerReachability reachabilityOf(DiscoveredServer server) =>
      reachability[server.id] ?? ServerReachability.unknown;

  /// Discovered and manual servers combined, deduplicated by host:port, with
  /// user-removed entries filtered out.
  List<DiscoveredServer> get allServers => {...discovered, ...manual}
      .where((server) => !dismissedIds.contains(server.id))
      .toList();
}

@freezed
sealed class DiscoveryState with _$DiscoveryState {
  const factory DiscoveryState({
    @Default(DiscoveryStatus.initial) DiscoveryStatus status,
    @Default(<DiscoveredServer>[]) List<DiscoveredServer> discovered,
    @Default(<DiscoveredServer>[]) List<DiscoveredServer> manual,
    @Default('') String errorMessage,

    /// The server whose reachability is currently being checked, so only that
    /// row shows a spinner.
    DiscoveredServer? checkingServer,

    /// Ids the user removed. mDNS keeps advertising a service after a swipe,
    /// so without this the next discovery emission re-adds it immediately.
    /// Cleared by an explicit rescan.
    @Default(<String>{}) Set<String> dismissedIds,

    /// Last known reachability per server id, refreshed on every scan.
    @Default(<String, ServerReachability>{})
    Map<String, ServerReachability> reachability,

    /// Set once when a tapped server is confirmed reachable; the screen
    /// navigates and then clears it via [DiscoveryEvent.consumeSignal].
    DiscoveredServer? verifiedServer,

    /// Set once when a tapped server turns out to be unreachable; the screen
    /// shows a toast and then clears it via [DiscoveryEvent.consumeSignal].
    String? unreachableMessage,
  }) = _DiscoveryState;
}
