import 'server_failure.dart';

/// The server could not be stopped.
class StopServerFailure extends ServerFailure {
  const StopServerFailure([super.message = 'Failed to stop the server. Try again']);
}
