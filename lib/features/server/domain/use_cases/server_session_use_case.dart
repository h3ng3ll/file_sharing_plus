import 'package:dartz/dartz.dart';

import '../../../../core/failures/failure.dart';
import '../failures/set_shared_folder_failure.dart';
import '../models/activity_log_entry.dart';
import '../models/connected_device.dart';
import '../repositories/i_server_repository.dart';

/// Exposes the live server session to the presentation layer: connected-device
/// and activity-log streams plus the shared-folder setter, all behind a use
/// case so the bloc never touches [IServerRepository] directly.
class ServerSessionUseCase {
  final IServerRepository _serverRepository;

  const ServerSessionUseCase({
    required IServerRepository serverRepository,
  }) : _serverRepository = serverRepository;

  /// Live connected-device list.
  Stream<List<ConnectedDevice>> get connectedDevices =>
      _serverRepository.connectedDevices;

  /// Live activity-log entries.
  Stream<ActivityLogEntry> get activityLog => _serverRepository.activityLog;

  /// Sets the shared folder. Left = done; Right = [Failure] on error.
  Future<Either<void, Failure>> setSharedFolder(String path) async {
    try {
      _serverRepository.setSharedFolder(path);
      return const Left(null);
    } catch (e) {
      return Right(SetSharedFolderFailure(e.toString()));
    }
  }
}
