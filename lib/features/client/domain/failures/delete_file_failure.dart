import 'client_failure.dart';

/// The file could not be deleted on the server.
class DeleteFileFailure extends ClientFailure {
  const DeleteFileFailure([
    super.message = 'Failed to delete the file. Try again',
  ]);
}
