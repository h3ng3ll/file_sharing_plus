part of 'server_bloc.dart';

@freezed
sealed class ServerEvent with _$ServerEvent {
  /// Subscribes to live device and activity streams.
  const factory ServerEvent.init() = _Init;

  const factory ServerEvent.startServer() = _StartServer;
  const factory ServerEvent.stopServer() = _StopServer;
  const factory ServerEvent.selectFolder() = _SelectFolder;
  const factory ServerEvent.refreshFiles() = _RefreshFiles;

  const factory ServerEvent.devicesUpdated(List<ConnectedDevice> devices) =
      _DevicesUpdated;
  const factory ServerEvent.logReceived(ActivityLogEntry entry) = _LogReceived;
}
