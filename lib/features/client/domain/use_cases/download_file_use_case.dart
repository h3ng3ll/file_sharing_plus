import '../../../../core/services/discovery_service.dart';
import '../models/transfer_progress.dart';
import '../repositories/i_client_repository.dart';

/// Downloads a file from a server, streaming progress.
class DownloadFileUseCase {
  final IClientRepository _clientRepository;

  const DownloadFileUseCase({
    required IClientRepository clientRepository,
  }) : _clientRepository = clientRepository;

  Stream<TransferProgress> call({
    required DiscoveredServer server,
    required String fileName,
    String path = '',
  }) {
    return _clientRepository.downloadFile(
      server: server,
      fileName: fileName,
      path: path,
    );
  }
}
