import '../../../../core/models/file_entry/file_entry.dart';
import '../../../../core/services/discovery_service.dart';
import '../repositories/i_client_repository.dart';

/// Fetches a server's file list for the given folder path.
class ListFilesUseCase {
  final IClientRepository _clientRepository;

  const ListFilesUseCase({
    required IClientRepository clientRepository,
  }) : _clientRepository = clientRepository;

  Future<List<FileEntry>> call({
    required DiscoveredServer server,
    String path = '',
  }) {
    return _clientRepository.listFiles(server: server, path: path);
  }
}
