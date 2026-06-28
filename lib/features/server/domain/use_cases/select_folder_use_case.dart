import 'package:file_picker/file_picker.dart';

/// Prompts the user to choose the folder that will be shared with clients.
class SelectFolderUseCase {
  const SelectFolderUseCase();

  /// Returns the selected directory path, or `null` if the user cancelled.
  Future<String?> call() {
    return FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Select folder to share',
    );
  }
}
