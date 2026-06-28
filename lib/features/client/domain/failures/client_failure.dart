import '../../../../core/failures/failure.dart';

/// Base type for failures originating in the client feature.
abstract class ClientFailure extends Failure {
  const ClientFailure(super.message);
}
