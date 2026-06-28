import 'server_failure.dart';

/// No folder was chosen (the user cancelled the picker).
class SelectFolderCancelledFailure extends ServerFailure {
  const SelectFolderCancelledFailure([super.message = 'No folder selected']);
}
