part of 'discovery_bloc.dart';

enum DiscoveryStatus {
  initial,
  discovering,
  validatingManual,
  failure,
}

extension DiscoveryStateX on DiscoveryState {
  bool get isDiscovering => status == DiscoveryStatus.discovering;
  bool get isValidatingManual => status == DiscoveryStatus.validatingManual;
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
  }) = _DiscoveryState;
}
