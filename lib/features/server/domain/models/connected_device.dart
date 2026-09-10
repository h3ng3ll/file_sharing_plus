import 'package:freezed_annotation/freezed_annotation.dart';

part 'connected_device.freezed.dart';

/// A client device that has made at least one successful request to a
/// recognised server endpoint during the current server session.
///
/// HTTP is stateless, so a plain request proves only that the device was
/// there at [lastSeen]. Real presence comes from [hasOpenEventStream]: while
/// the client holds the `/events` WebSocket open, it is genuinely connected,
/// and the socket closing is an immediate, reliable disconnect signal.
@freezed
sealed class ConnectedDevice with _$ConnectedDevice {
  const factory ConnectedDevice({
    required String address,
    required DateTime lastSeen,
    @Default(0) int requestCount,

    /// Whether this device currently holds an open `/events` WebSocket.
    @Default(false) bool hasOpenEventStream,
  }) = _ConnectedDevice;
}
