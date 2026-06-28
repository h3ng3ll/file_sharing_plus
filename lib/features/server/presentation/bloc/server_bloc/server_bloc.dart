import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:path/path.dart' as p;

import '../../../../../core/models/file_entry/file_entry.dart';
import '../../../domain/models/activity_log_entry.dart';
import '../../../domain/models/connected_device.dart';
import '../../../domain/use_cases/select_folder_use_case.dart';
import '../../../domain/use_cases/server_session_use_case.dart';
import '../../../domain/use_cases/start_server_use_case.dart';
import '../../../domain/use_cases/stop_server_use_case.dart';

part 'server_event.dart';
part 'server_state.dart';
part 'server_bloc.freezed.dart';

/// Drives the macOS server screen: start/stop, shared folder, live activity.
class ServerBloc extends Bloc<ServerEvent, ServerState> {
  final ServerSessionUseCase _serverSessionUseCase;
  final StartServerUseCase _startServerUseCase;
  final StopServerUseCase _stopServerUseCase;
  final SelectFolderUseCase _selectFolderUseCase;

  ServerBloc({
    required ServerSessionUseCase serverSessionUseCase,
    required StartServerUseCase startServerUseCase,
    required StopServerUseCase stopServerUseCase,
    required SelectFolderUseCase selectFolderUseCase,
  })  : _serverSessionUseCase = serverSessionUseCase,
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
    _serverSessionUseCase.connectedDevices.listen(
      (devices) => add(ServerEvent.devicesUpdated(devices)),
    );
    _serverSessionUseCase.activityLog.listen(
      (entry) => add(ServerEvent.logReceived(entry)),
    );
  }

  Future<void> _startServer(
    _StartServer event,
    Emitter<ServerState> emit,
  ) async {
    emit(state.copyWith(status: ServerStatus.starting));
    final result = await _startServerUseCase(port: state.port);
    result.fold(
      (data) => emit(
        state.copyWith(
          status: ServerStatus.running,
          port: data.port,
          ipAddress: data.ipAddress,
        ),
      ),
      (failure) => emit(
        state.copyWith(
          status: ServerStatus.failure,
          errorMessage: failure.message,
        ),
      ),
    );
  }

  Future<void> _stopServer(
    _StopServer event,
    Emitter<ServerState> emit,
  ) async {
    final result = await _stopServerUseCase();
    result.fold(
      (_) => emit(
        state.copyWith(
          status: ServerStatus.stopped,
          devices: const [],
        ),
      ),
      (failure) => emit(
        state.copyWith(
          status: ServerStatus.failure,
          errorMessage: failure.message,
        ),
      ),
    );
  }

  Future<void> _selectFolder(
    _SelectFolder event,
    Emitter<ServerState> emit,
  ) async {
    final result = await _selectFolderUseCase();
    await result.fold(
      (path) async {
        final setResult = await _serverSessionUseCase.setSharedFolder(path);
        setResult.fold(
          (_) {
            emit(state.copyWith(sharedFolder: path));
            add(const ServerEvent.refreshFiles());
          },
          (failure) => emit(
            state.copyWith(
              status: ServerStatus.failure,
              errorMessage: failure.message,
            ),
          ),
        );
      },
      // Cancellation (SelectFolderCancelledFailure) → no-op.
      (failure) async {},
    );
  }

  Future<void> _refreshFiles(
    _RefreshFiles event,
    Emitter<ServerState> emit,
  ) async {
    final folder = state.sharedFolder;
    if (folder == null) return;

    try {
      final entries = <FileEntry>[];
      await for (final entity in Directory(folder).list(followLinks: false)) {
        entries.add(
          FileEntry(
            name: p.basename(entity.path),
            isDirectory: entity is Directory,
            size: _entrySize(entity),
          ),
        );
      }
      emit(state.copyWith(files: entries));
    } catch (_) {
      emit(
        state.copyWith(
          status: ServerStatus.failure,
          errorMessage: 'Failed to read the shared folder',
        ),
      );
    }
  }

  /// Size in bytes for a directory entry. Returns 0 for directories, symlinks
  /// ([Link]) and any entry whose length cannot be read.
  int _entrySize(FileSystemEntity entity) {
    if (entity is! File) return 0;
    try {
      return entity.lengthSync();
    } catch (_) {
      return 0;
    }
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
