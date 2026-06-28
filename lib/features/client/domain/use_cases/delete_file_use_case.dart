import 'package:dartz/dartz.dart';

import '../../../../core/failures/failure.dart';
import '../../../../core/services/discovery_service.dart';
import '../failures/delete_file_failure.dart';
import '../repositories/i_client_repository.dart';

/// Deletes a file on the server.
class DeleteFileUseCase {
  final IClientRepository _clientRepository;

  const DeleteFileUseCase({
    required IClientRepository clientRepository,
  }) : _clientRepository = clientRepository;

  /// Left = deleted; Right = [DeleteFileFailure] on error.
  Future<Either<void, Failure>> call({
    required DiscoveredServer server,
    required String fileName,
    String path = '',
  }) async {
    try {
      await _clientRepository.deleteFile(
        server: server,
        fileName: fileName,
        path: path,
      );
      return const Left(null);
    } catch (_) {
      return const Right(DeleteFileFailure());
    }
  }
}
