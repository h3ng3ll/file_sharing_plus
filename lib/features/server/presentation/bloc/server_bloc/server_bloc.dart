import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:path/path.dart' as p;

import '../../../../../core/models/file_entry/file_entry.dart';
import '../../../domain/models/activity_log_entry.dart';
import '../../../domain/models/connected_device.dart';
import '../../../domain/repositories/i_server_repository.dart';
import '../../../domain/use_cases/select_folder_use_case.dart';
import '../../../domain/use_cases/start_server_use_case.dart';
import '../../../domain/use_cases/stop_server_use_case.dart';

part 'server_event.dart';
part 'server_state.dart';
part 'server_bloc.freezed.dart';

/// Drives the macOS server screen: start/stop, shared folder, live activity.
class ServerBloc extends Bloc<ServerEvent, ServerState> {
  final IServerRepository _serverRepository;
  final StartServerUseCase _startServerUseCase;
  final StopServerUseCase _stopServerUseCase;
  final SelectFolderUseCase _selectFolderUseCase;

  ServerBloc({
    required IServerRepository serverRepository,
    required StartServerUseCase startServerUseCase,
    required StopServerUseCase stopServerUseCase,
    required SelectFolderUseCase selectFolderUseCase,
  })  : _serverRepository = serverRepository,
        _startServerUseCase = startServerUseCase,
        _stopServerUseCase = stopServerUseCase,
        _selectFolderUseCase = selectFolderUseCase,
        super(const ServerState()) {
    on<_Init>(_init);
    on<_StartServer>(_startServer);
    on<_StopServer>(_stopServer);
    on<_SelectFolder>(_selectFolder);
    on<_DevicesUpdated>(_devicesUpdated);
    on<_LogReceived>(_logReceived);
    on<_RefreshFiles>(_refreshFiles);
  }

  void _init(_Init event, Emitter<ServerState> emit) {
    _serverRepository.connectedDevices.listen(
      (devices) => add(ServerEvent.devicesUpdated(devices)),
    );
    _serverRepository.activityLog.listen(
      (entry) => add(ServerEvent.logReceived(entry)),
    );
  }

  Future<void> _startServer(
    _StartServer event,
    Emitter<ServerState> emit,
  ) async {
    emit(state.copyWith(status: ServerStatus.starting));
    try {
      final result = await _startServerUseCase(port: state.port);
      emit(
        state.copyWith(
          status: ServerStatus.running,
          port: result.port,
          ipAddress: result.ipAddress,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ServerStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _stopServer(
    _StopServer event,
    Emitter<ServerState> emit,
  ) async {
    try {
      await _stopServerUseCase();
      emit(
        state.copyWith(
          status: ServerStatus.stopped,
          devices: const [],
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ServerStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _selectFolder(
    _SelectFolder event,
    Emitter<ServerState> emit,
  ) async {
    final path = await _selectFolderUseCase();
    if (path == null) return;
    _serverRepository.setSharedFolder(path);
    emit(state.copyWith(sharedFolder: path));
    add(const ServerEvent.refreshFiles());
  }

  Future<void> _refreshFiles(
    _RefreshFiles event,
    Emitter<ServerState> emit,
  ) async {
    final folder = state.sharedFolder;
    if (folder == null) return;

    final entries = <FileEntry>[];
    await for (final entity in Directory(folder).list(followLinks: false)) {
      final isDir = entity is Directory;
      entries.add(
        FileEntry(
          name: p.basename(entity.path),
          isDirectory: isDir,
          size: isDir ? 0 : (entity as File).lengthSync(),
        ),
      );
    }
    emit(state.copyWith(files: entries));
  }

  void _devicesUpdated(_DevicesUpdated event, Emitter<ServerState> emit) {
    emit(state.copyWith(devices: event.devices));
  }

  void _logReceived(_LogReceived event, Emitter<ServerState> emit) {
    final updated = [event.entry, ...state.log];
    emit(state.copyWith(log: updated.take(100).toList()));
    if (event.entry.type == ActivityType.upload) {
      add(const ServerEvent.refreshFiles());
    }
  }
}
