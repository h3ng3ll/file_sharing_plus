import 'server_failure.dart';

/// The server could not be started.
class StartServerFailure extends ServerFailure {
  const StartServerFailure([super.message = 'Failed to start the server. Try again']);
}
