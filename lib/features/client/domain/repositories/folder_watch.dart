import '../../../../core/models/file_entry/file_entry.dart';

/// A live connection that streams a server folder's contents.
///
/// Returned by [IClientRepository.watchFiles]. The presentation layer listens
/// to [files] for updates and calls [watch] to change which folder path is
/// being streamed (on navigation). Networking details are hidden behind this
/// handle so the transport (currently a WebSocket) stays replaceable.
abstract interface class FolderWatch {
  /// Emits the folder's contents on connect and on every change.
  Stream<List<FileEntry>> get files;

  /// Switches the watched folder to [path] (relative to the shared root).
  void watch(String path);

  /// Closes the underlying connection and releases resources.
  Future<void> close();
}
