import '../../../../core/models/file_entry/file_entry.dart';
import '../../../../core/services/discovery_service.dart';
import '../models/transfer_progress.dart';
import 'folder_watch.dart';

/// Hides the HTTP client and networking details from the presentation layer.
///
/// Networking is therefore replaceable without touching blocs or widgets.
abstract interface class IClientRepository {
  /// Verifies a server is reachable at [host]:[port] via `GET /ping`.
  Future<bool> ping({required String host, required int port});

  /// Fetches the file list for [server] under the optional [path].
  Future<List<FileEntry>> listFiles({
    required DiscoveredServer server,
    String path,
  });

  /// Downloads [fileName] (relative to [path]) from [server] into the device's
  /// downloads directory, emitting [TransferProgress] as bytes arrive.
  Stream<TransferProgress> downloadFile({
    required DiscoveredServer server,
    required String fileName,
    String path,
  });

  /// Uploads the local file at [filePath] to [server], emitting
  /// [TransferProgress] as bytes are sent.
  Stream<TransferProgress> uploadFile({
    required DiscoveredServer server,
    required String filePath,
  });

  /// Opens a live [FolderWatch] for [server] that streams folder listings and
  /// re-pushes them whenever the server's shared folder changes.
  FolderWatch watchFiles({required DiscoveredServer server});

  /// Deletes [fileName] (relative to [path]) on [server]. Throws on failure.
  Future<void> deleteFile({
    required DiscoveredServer server,
    required String fileName,
    String path,
  });
}
