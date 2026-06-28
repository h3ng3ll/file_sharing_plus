import 'package:freezed_annotation/freezed_annotation.dart';

part 'connected_device.freezed.dart';

/// A client device that has connected to the server at least once.
@freezed
sealed class ConnectedDevice with _$ConnectedDevice {
  const factory ConnectedDevice({
    required String address,
    required DateTime lastSeen,
    @Default(0) int requestCount,
  }) = _ConnectedDevice;
}
