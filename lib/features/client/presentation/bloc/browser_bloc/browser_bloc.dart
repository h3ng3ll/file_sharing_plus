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

part 'browser_event.dart';
part 'browser_state.dart';
part 'browser_bloc.freezed.dart';

/// Drives the iOS file-browser screen for a single connected [DiscoveredServer].
class BrowserBloc extends Bloc<BrowserEvent, BrowserState> {
  final ListFilesUseCase _listFilesUseCase;
  final DownloadFileUseCase _downloadFileUseCase;
  final UploadFileUseCase _uploadFileUseCase;

  BrowserBloc({
    required ListFilesUseCase listFilesUseCase,
    required DownloadFileUseCase downloadFileUseCase,
    required UploadFileUseCase uploadFileUseCase,
  })  : _listFilesUseCase = listFilesUseCase,
        _downloadFileUseCase = downloadFileUseCase,
        _uploadFileUseCase = uploadFileUseCase,
        super(const BrowserState()) {
    on<_Init>(_init);
    on<_OpenFolder>(_openFolder);
    on<_GoUp>(_goUp);
    on<_LoadFiles>(_loadFiles);
    on<_Download>(_download);
    on<_PickAndUpload>(_pickAndUpload);
    on<_TransferFinished>(_transferFinished);
  }

  void _init(_Init event, Emitter<BrowserState> emit) {
    emit(state.copyWith(server: event.server, path: ''));
    add(const BrowserEvent.loadFiles());
  }

  Future<void> _loadFiles(
    _LoadFiles event,
    Emitter<BrowserState> emit,
  ) async {
    final server = state.server;
    if (server == null) return;
    emit(state.copyWith(status: BrowserStatus.loading));
    try {
      final files = await _listFilesUseCase(
        server: server,
        path: state.path,
      );
      emit(state.copyWith(status: BrowserStatus.loaded, files: files));
    } catch (e) {
      emit(
        state.copyWith(
          status: BrowserStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _openFolder(_OpenFolder event, Emitter<BrowserState> emit) {
    final newPath =
        state.path.isEmpty ? event.name : p.join(state.path, event.name);
    emit(state.copyWith(path: newPath));
    add(const BrowserEvent.loadFiles());
  }

  void _goUp(_GoUp event, Emitter<BrowserState> emit) {
    if (state.path.isEmpty) return;
    final parent = p.dirname(state.path);
    emit(state.copyWith(path: parent == '.' ? '' : parent));
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
    );
    emit(
      state.copyWith(
        progress: null,
        errorMessage: '',
        history: [record, ...state.history].take(50).toList(),
      ),
    );
  }
}
