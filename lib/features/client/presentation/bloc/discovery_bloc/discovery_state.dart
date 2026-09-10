part of 'discovery_bloc.dart';

enum DiscoveryStatus {
  initial,
  discovering,
  validatingManual,
  checkingServer,
  failure,
}

extension DiscoveryStateX on DiscoveryState {
  bool get isDiscovering => status == DiscoveryStatus.discovering;
  bool get isValidatingManual => status == DiscoveryStatus.validatingManual;
  bool get isCheckingServer => status == DiscoveryStatus.checkingServer;
  bool get isFailure => status == DiscoveryStatus.failure;

  /// Discovered and manual servers combined, deduplicated by host:port.
  List<DiscoveredServer> get allServers =>
      {...discovered, ...manual}.toList();
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

    /// Set once when a tapped server is confirmed reachable; the screen
    /// navigates and then clears it via [DiscoveryEvent.consumeSignal].
    DiscoveredServer? verifiedServer,

    /// Set once when a tapped server turns out to be unreachable; the screen
    /// shows a toast and then clears it via [DiscoveryEvent.consumeSignal].
    String? unreachableMessage,
  }) = _DiscoveryState;
}
