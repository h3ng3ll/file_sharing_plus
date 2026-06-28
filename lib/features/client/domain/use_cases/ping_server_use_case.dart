import 'package:dartz/dartz.dart';

import '../../../../core/failures/failure.dart';
import '../failures/ping_failure.dart';
import '../repositories/i_client_repository.dart';

/// Verifies a server is reachable at [host]:[port].
class PingServerUseCase {
  final IClientRepository _clientRepository;

  const PingServerUseCase({
    required IClientRepository clientRepository,
  }) : _clientRepository = clientRepository;

  /// Left = reachable; Right = [PingFailure] (unreachable or error).
  Future<Either<void, Failure>> call({
    required String host,
    required int port,
  }) async {
    try {
      final reachable = await _clientRepository.ping(host: host, port: port);
      if (!reachable) {
        return Right(PingFailure('No server reachable at $host:$port'));
      }
      return const Left(null);
    } catch (_) {
      return Right(PingFailure('No server reachable at $host:$port'));
    }
  }
}
