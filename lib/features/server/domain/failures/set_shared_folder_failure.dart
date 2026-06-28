import 'server_failure.dart';

/// The shared folder could not be set.
class SetSharedFolderFailure extends ServerFailure {
  const SetSharedFolderFailure([super.message = 'Failed to set shared folder']);
}
