import '../../../../core/failures/failure.dart';

/// Base type for failures originating in the server feature.
abstract class ServerFailure extends Failure {
  const ServerFailure(super.message);
}
