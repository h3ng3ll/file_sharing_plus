part of 'browser_bloc.dart';

@freezed
sealed class BrowserEvent with _$BrowserEvent {
  /// Binds the browser to a server and loads its root listing.
  const factory BrowserEvent.init(DiscoveredServer server) = _Init;

  const factory BrowserEvent.loadFiles() = _LoadFiles;
  const factory BrowserEvent.openFolder(String name) = _OpenFolder;
  const factory BrowserEvent.goUp() = _GoUp;
  const factory BrowserEvent.download(String fileName) = _Download;
  const factory BrowserEvent.pickAndUpload() = _PickAndUpload;

  const factory BrowserEvent.transferFinished({
    required String fileName,
    required TransferDirection direction,
    required bool success,
  }) = _TransferFinished;
}
