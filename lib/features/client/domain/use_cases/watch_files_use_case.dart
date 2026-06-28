import '../../../../core/models/file_entry/file_entry.dart';
import '../../../../core/services/discovery_service.dart';
import '../repositories/folder_watch.dart';
import '../repositories/i_client_repository.dart';

/// Opens a live folder watch for a server and exposes its updates.
///
/// Mirrors the start/stop + stream shape of `DiscoverServersUseCase`: call
/// [start] once for a server, [watch] on every navigation, listen to [files],
/// and [stop] when done.
class WatchFilesUseCase {
  final IClientRepository _clientRepository;

  WatchFilesUseCase({
    required IClientRepository clientRepository,
  }) : _clientRepository = clientRepository;

  FolderWatch? _watch;

  /// Live stream of folder listings pushed by the server.
  Stream<List<FileEntry>> get files =>
      _watch?.files ?? const Stream<List<FileEntry>>.empty();

  /// Opens the watch connection for [server].
  void start(DiscoveredServer server) {
    _watch ??= _clientRepository.watchFiles(server: server);
  }

  /// Streams the folder at [path] (relative to the shared root).
  void watch(String path) => _watch?.watch(path);

  /// Closes the watch connection.
  Future<void> stop() async {
    await _watch?.close();
    _watch = null;
  }
}
