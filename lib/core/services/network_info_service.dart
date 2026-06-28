import 'dart:io';

/// Resolves information about the device's local network presence.
///
/// Pure `dart:io` — no platform channels. Used by the server to display the
/// address clients should connect to.
class NetworkInfoService {
  /// Returns the first non-loopback IPv4 address, or `null` when the device is
  /// not connected to any network.
  Future<String?> getLocalIpAddress() async {
    final interfaces = await NetworkInterface.list(
      type: InternetAddressType.IPv4,
      includeLoopback: false,
      includeLinkLocal: false,
    );

    for (final interface in interfaces) {
      for (final address in interface.addresses) {
        if (!address.isLoopback) {
          return address.address;
        }
      }
    }
    return null;
  }
}
