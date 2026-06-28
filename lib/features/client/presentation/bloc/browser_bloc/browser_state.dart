part of 'browser_bloc.dart';

enum BrowserStatus {
  initial,
  loading,
  loaded,
  failure,
}

extension BrowserStateX on BrowserState {
  bool get isLoading => status == BrowserStatus.loading;
  bool get isLoaded => status == BrowserStatus.loaded;
  bool get isFailure => status == BrowserStatus.failure;
  bool get isTransferring => progress != null && !progress!.isComplete;
  bool get isAtRoot => path.isEmpty;
}

@freezed
sealed class BrowserState with _$BrowserState {
  const factory BrowserState({
    @Default(BrowserStatus.initial) BrowserStatus status,
    DiscoveredServer? server,
    @Default('') String path,
    @Default(<FileEntry>[]) List<FileEntry> files,
    TransferProgress? progress,
    @Default(<TransferRecord>[]) List<TransferRecord> history,
    @Default('') String errorMessage,
  }) = _BrowserState;
}
