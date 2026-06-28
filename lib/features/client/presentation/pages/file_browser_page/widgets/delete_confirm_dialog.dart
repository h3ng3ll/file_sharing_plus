import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_colors.dart';

/// Confirmation dialog shown before deleting a server file.
///
/// Pops `true` when the user confirms, `false`/`null` otherwise — so an
/// accidental tap on the trash icon never removes a file.
class DeleteConfirmDialog extends StatelessWidget {
  final String fileName;

  const DeleteConfirmDialog({
    super.key,
    required this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete file?'),
      content: Text('Delete "$fileName"? This cannot be undone.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.danger.value,
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
