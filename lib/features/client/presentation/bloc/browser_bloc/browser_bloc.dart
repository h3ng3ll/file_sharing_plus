import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:path/path.dart' as p;

import '../../../../../core/models/file_entry/file_entry.dart';
import '../../../../../core/services/discovery_service.dart';
import '../../../domain/models/transfer_progress.dart';
import '../../../domain/models/transfer_record.dart';
import '../../../domain/use_cases/download_file_use_case.dart';
import '../../../domain/use_cases/list_files_use_case.dart';
import '../../../domain/use_cases/upload_file_use_case.dart';
import '../../../domain/use_cases/watch_files_use_case.dart';

part 'browser_event.dart';
part 'browser_state.dart';
part 'browser_bloc.freezed.dart';

/// Drives the iOS file-browser screen for a single connected [DiscoveredServer].
class BrowserBloc extends Bloc<BrowserEvent, BrowserState> {
  final ListFilesUseCase _listFilesUseCase;
  final DownloadFileUseCase _downloadFileUseCase;
  final UploadFileUseCase _uploadFileUseCase;
  final WatchFilesUseCase _watchFilesUseCase;

  BrowserBloc({
    required ListFilesUseCase listFilesUseCase,
    required DownloadFileUseCase downloadFileUseCase,
    required UploadFileUseCase uploadFileUseCase,
    required WatchFilesUseCase watchFilesUseCase,
  })  : _listFilesUseCase = listFilesUseCase,
        _downloadFileUseCase = downloadFileUseCase,
        _uploadFileUseCase = uploadFileUseCase,
        _watchFilesUseCase = watchFilesUseCase,
        super(const BrowserState()) {
    on<_Init>(_init);
    on<_OpenFolder>(_openFolder);
    on<_GoUp>(_goUp);
    on<_LoadFiles>(_loadFiles);
    on<_Download>(_download);
    on<_PickAndUpload>(_pickAndUpload);
    on<_TransferFinished>(_transferFinished);
    on<_StartWatching>(_startWatching);
  }

  void _init(_Init event, Emitter<BrowserState> emit) {
    emit(state.copyWith(server: event.server, path: ''));
    // Open the live folder watch, then load once over HTTP for first paint /
    // fallback if the socket is slow or unavailable.
    _watchFilesUseCase.start(event.server);
    add(const BrowserEvent.startWatching());
    _watchFilesUseCase.watch('');
    add(const BrowserEvent.loadFiles());
  }

  /// Long-lived handler: streams server-pushed listings into the bloc.
  ///
  /// Runs for the bloc's lifetime via [emit.forEach]; because it handles a
  /// distinct event type, it does not block navigation or transfer handlers.
  Future<void> _startWatching(
    _StartWatching event,
    Emitter<BrowserState> emit,
  ) async {
    await emit.forEach<List<FileEntry>>(
      _watchFilesUseCase.files,
      onData: (files) => state.copyWith(
        status: BrowserStatus.loaded,
        files: files,
        errorMessage: '',
      ),
      // Keep the last good listing visible, but surface that the live
      // connection dropped so a listener can notify the user.
      onError: (_, _) =>
          state.copyWith(errorMessage: 'Live updates disconnected'),
    );
  }

  Future<void> _loadFiles(
    _LoadFiles event,
    Emitter<BrowserState> emit,
  ) async {
    final server = state.server;
    if (server == null) return;
    emit(state.copyWith(status: BrowserStatus.loading));
    final result = await _listFilesUseCase(
      server: server,
      path: state.path,
    );
    result.fold(
      (files) =>
          emit(state.copyWith(status: BrowserStatus.loaded, files: files)),
      (failure) => emit(
        state.copyWith(
          status: BrowserStatus.failure,
          errorMessage: failure.message,
        ),
      ),
    );
  }

  void _openFolder(_OpenFolder event, Emitter<BrowserState> emit) {
    final newPath =
        state.path.isEmpty ? event.name : p.join(state.path, event.name);
    emit(state.copyWith(path: newPath));
    // Point the live watch at the new folder; load once for immediate paint.
    _watchFilesUseCase.watch(newPath);
    add(const BrowserEvent.loadFiles());
  }

  void _goUp(_GoUp event, Emitter<BrowserState> emit) {
    if (state.path.isEmpty) return;
    final parent = p.dirname(state.path);
    final newPath = parent == '.' ? '' : parent;
    emit(state.copyWith(path: newPath));
    _watchFilesUseCase.watch(newPath);
    add(const BrowserEvent.loadFiles());
  }

  Future<void> _download(_Download event, Emitter<BrowserState> emit) async {
    final server = state.server;
    if (server == null) return;
    emit(state.copyWith(errorMessage: ''));
    await emit.forEach<TransferProgress>(
      _downloadFileUseCase(
        server: server,
        fileName: event.fileName,
        path: state.path,
      ),
      onData: (progress) => state.copyWith(progress: progress),
      onError: (error, _) => state.copyWith(
        progress: null,
        errorMessage: error.toString(),
      ),
    );
    add(
      BrowserEvent.transferFinished(
        fileName: event.fileName,
        direction: TransferDirection.download,
        success: state.errorMessage.isEmpty,
        savedPath: state.progress?.savedPath,
      ),
    );
  }

  Future<void> _pickAndUpload(
    _PickAndUpload event,
    Emitter<BrowserState> emit,
  ) async {
    final server = state.server;
    if (server == null) return;
    final filePath = await _uploadFileUseCase.pickFile();
    if (filePath == null) return;

    final fileName = p.basename(filePath);
    emit(state.copyWith(errorMessage: ''));
    await emit.forEach<TransferProgress>(
      _uploadFileUseCase(server: server, filePath: filePath),
      onData: (progress) => state.copyWith(progress: progress),
      onError: (error, _) => state.copyWith(
        progress: null,
        errorMessage: error.toString(),
      ),
    );
    add(
      BrowserEvent.transferFinished(
        fileName: fileName,
        direction: TransferDirection.upload,
        success: state.errorMessage.isEmpty,
      ),
    );
    add(const BrowserEvent.loadFiles());
  }

  void _transferFinished(
    _TransferFinished event,
    Emitter<BrowserState> emit,
  ) {
    final record = TransferRecord(
      fileName: event.fileName,
      direction: event.direction,
      success: event.success,
      timestamp: DateTime.now(),
      savedPath: event.savedPath,
    );
    emit(
      state.copyWith(
        progress: null,
        errorMessage: '',
        history: [record, ...state.history].take(50).toList(),
      ),
    );
  }

  @override
  Future<void> close() async {
    await _watchFilesUseCase.stop();
    return super.close();
  }
}
