import 'client_failure.dart';

/// The target host could not be reached.
class PingFailure extends ClientFailure {
  const PingFailure([super.message = 'No server reachable at the given address']);
}
