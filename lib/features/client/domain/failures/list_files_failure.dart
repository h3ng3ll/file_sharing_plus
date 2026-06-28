import 'client_failure.dart';

/// The file listing could not be loaded.
class ListFilesFailure extends ClientFailure {
  const ListFilesFailure([super.message = 'Failed to load files. Try again']);
}
