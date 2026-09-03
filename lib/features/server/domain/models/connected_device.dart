import 'package:freezed_annotation/freezed_annotation.dart';

part 'connected_device.freezed.dart';

/// A client device that has made at least one successful request to a
/// recognised server endpoint during the current server session.
@freezed
sealed class ConnectedDevice with _$ConnectedDevice {
  const factory ConnectedDevice({
    required String address,
    required DateTime lastSeen,
    @Default(0) int requestCount,
  }) = _ConnectedDevice;
}
