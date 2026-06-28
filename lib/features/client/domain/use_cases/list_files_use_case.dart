import 'package:dartz/dartz.dart';

import '../../../../core/failures/failure.dart';
import '../../../../core/models/file_entry/file_entry.dart';
import '../../../../core/services/discovery_service.dart';
import '../failures/list_files_failure.dart';
import '../repositories/i_client_repository.dart';

/// Fetches a server's file list for the given folder path.
class ListFilesUseCase {
  final IClientRepository _clientRepository;

  const ListFilesUseCase({
    required IClientRepository clientRepository,
  }) : _clientRepository = clientRepository;

  /// Left = file list; Right = [ListFilesFailure] on error.
  Future<Either<List<FileEntry>, Failure>> call({
    required DiscoveredServer server,
    String path = '',
  }) async {
    try {
      final files = await _clientRepository.listFiles(server: server, path: path);
      return Left(files);
    } catch (e) {
      return Right(ListFilesFailure(e.toString()));
    }
  }
}
