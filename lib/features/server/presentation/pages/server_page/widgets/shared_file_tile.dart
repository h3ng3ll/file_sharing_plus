import 'package:flutter/material.dart';

import '../../../../../../core/models/file_entry/file_entry.dart';
import '../../../../../../core/resources/colors/app_colors.dart';
import '../../../../../../core/resources/text/app_text_style.dart';
import '../../../../../../core/utils/extensions/int_size_x.dart';

/// A single row in the Shared Files list: icon, name and (for files) size.
class SharedFileTile extends StatelessWidget {
  final FileEntry file;

  const SharedFileTile({
    super.key,
    required this.file,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        file.isDirectory ? Icons.folder : Icons.insert_drive_file,
        color: AppColors.primary.value,
      ),
      title: Text(
        file.name,
        style: AppTextStyle.regular14.value,
      ),
      trailing: file.isDirectory
          ? null
          : Text(
              file.size.readableSize,
              style: AppTextStyle.regular12.value.copyWith(
                color: AppColors.textSecondary.value,
              ),
            ),
    );
  }
}
