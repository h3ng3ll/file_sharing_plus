part of 'server_bloc.dart';

enum ServerStatus {
  stopped,
  starting,
  running,
  failure,
}

extension ServerStateX on ServerState {
  bool get isRunning => status == ServerStatus.running;
  bool get isStarting => status == ServerStatus.starting;
  bool get isStopped => status == ServerStatus.stopped;
  bool get isFailure => status == ServerStatus.failure;
  bool get hasSharedFolder => sharedFolder != null;
}

@freezed
sealed class ServerState with _$ServerState {
  const factory ServerState({
    @Default(ServerStatus.stopped) ServerStatus status,
    @Default(8080) int port,
    String? ipAddress,
    String? sharedFolder,
    @Default(<FileEntry>[]) List<FileEntry> files,
    @Default(<ConnectedDevice>[]) List<ConnectedDevice> devices,
    @Default(<ActivityLogEntry>[]) List<ActivityLogEntry> log,
    @Default('') String errorMessage,
  }) = _ServerState;
}
