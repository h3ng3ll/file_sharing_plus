import 'package:file_picker/file_picker.dart';

import '../../../../core/services/discovery_service.dart';
import '../models/transfer_progress.dart';
import '../repositories/i_client_repository.dart';

/// Picks a file from the Files app and uploads it, streaming progress.
class UploadFileUseCase {
  final IClientRepository _clientRepository;

  const UploadFileUseCase({
    required IClientRepository clientRepository,
  }) : _clientRepository = clientRepository;

  /// Prompts the user to choose a file. Returns its path, or `null` if
  /// cancelled.
  Future<String?> pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    return result?.files.single.path;
  }

  /// Uploads the local file at [filePath] to [server].
  Stream<TransferProgress> call({
    required DiscoveredServer server,
    required String filePath,
  }) {
    return _clientRepository.uploadFile(server: server, filePath: filePath);
  }
}
