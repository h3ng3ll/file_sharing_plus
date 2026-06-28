import 'package:dartz/dartz.dart';

import '../../../../core/failures/failure.dart';
import '../../../../core/services/discovery_service.dart';
import '../failures/stop_server_failure.dart';
import '../repositories/i_server_repository.dart';

/// Orchestrates stopping the HTTP server and withdrawing the Bonjour service.
class StopServerUseCase {
  final IServerRepository _serverRepository;
  final DiscoveryService _discoveryService;

  const StopServerUseCase({
    required IServerRepository serverRepository,
    required DiscoveryService discoveryService,
  })  : _serverRepository = serverRepository,
        _discoveryService = discoveryService;

  /// Left = stopped; Right = [StopServerFailure] on error.
  Future<Either<void, Failure>> call() async {
    try {
      await _discoveryService.unregisterServer();
      await _serverRepository.stop();
      return const Left(null);
    } catch (e) {
      return Right(StopServerFailure(e.toString()));
    }
  }
}
