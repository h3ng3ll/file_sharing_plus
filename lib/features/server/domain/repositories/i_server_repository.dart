import '../models/activity_log_entry.dart';
import '../models/connected_device.dart';

/// Hides the HTTP server and networking details behind a stable contract.
///
/// Implementations stream live server activity so the presentation layer never
/// touches `dart:io` directly. Networking is therefore replaceable.
abstract interface class IServerRepository {
  /// Emits the connected-device list whenever it changes.
  Stream<List<ConnectedDevice>> get connectedDevices;

  /// Emits new activity-log entries as they happen.
  Stream<ActivityLogEntry> get activityLog;

  /// Sets the folder whose contents are shared with clients.
  void setSharedFolder(String path);

  /// Starts the HTTP server on [port], returning the actual bound port.
  ///
  /// Passing port `0` lets the OS choose a free port.
  Future<int> start({int port});

  /// Stops the HTTP server and releases the socket.
  Future<void> stop();
}
