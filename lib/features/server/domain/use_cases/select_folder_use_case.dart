import 'package:dartz/dartz.dart';
import 'package:file_picker/file_picker.dart';

import '../../../../core/failures/failure.dart';
import '../failures/select_folder_failure.dart';

/// Prompts the user to choose the folder that will be shared with clients.
class SelectFolderUseCase {
  const SelectFolderUseCase();

  /// Left = selected directory path; Right = [SelectFolderCancelledFailure]
  /// when the user cancelled the picker.
  Future<Either<String, Failure>> call() async {
    final path = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Select folder to share',
    );
    if (path == null) return const Right(SelectFolderCancelledFailure());
    return Left(path);
  }
}
