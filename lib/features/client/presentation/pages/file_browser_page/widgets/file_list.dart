import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/models/file_entry/file_entry.dart';
import '../../../../../../core/resources/colors/app_colors.dart';
import '../../../../../../core/resources/text/app_text_style.dart';
import '../../../../../../core/utils/extensions/int_size_x.dart';
import '../../../bloc/browser_bloc/browser_bloc.dart';
import 'delete_confirm_dialog.dart';

/// Lists files and folders for the current path.
class FileList extends StatelessWidget {
  const FileList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BrowserBloc, BrowserState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.isFailure) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                state.errorMessage,
                textAlign: TextAlign.center,
                style: AppTextStyle.regular14.value.copyWith(
                  color: AppColors.danger.value,
                ),
              ),
            ),
          );
        }
        if (state.files.isEmpty) {
          return Center(
            child: Text(
              'This folder is empty',
              style: AppTextStyle.regular14.value.copyWith(
                color: AppColors.textSecondary.value,
              ),
            ),
          );
        }

        return ListView.separated(
          itemCount: state.files.length,
          separatorBuilder: (_, _) => const Divider(height: 1.0),
          itemBuilder: (context, index) => _FileTile(
            file: state.files[index],
            transferInProgress: state.isTransferring,
          ),
        );
      },
    );
  }
}

/// A single file/folder row with its actions (open, download, delete).
class _FileTile extends StatelessWidget {
  final FileEntry file;
  final bool transferInProgress;

  const _FileTile({
    required this.file,
    required this.transferInProgress,
  });

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => DeleteConfirmDialog(fileName: file.name),
    );
    if (confirmed == true && context.mounted) {
      context.read<BrowserBloc>().add(BrowserEvent.deleteFile(file.name));
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<BrowserBloc>();
    return ListTile(
      leading: Icon(
        file.isDirectory ? Icons.folder : Icons.insert_drive_file,
        color: AppColors.primary.value,
      ),
      title: Text(
        file.name,
        style: AppTextStyle.regular14.value,
      ),
      subtitle: file.isDirectory
          ? null
          : Text(
              file.size.readableSize,
              style: AppTextStyle.regular12.value.copyWith(
                color: AppColors.textSecondary.value,
              ),
            ),
      trailing: file.isDirectory
          ? const Icon(Icons.chevron_right)
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: transferInProgress
                      ? null
                      : () => bloc.add(BrowserEvent.download(file.name)),
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: AppColors.danger.value,
                  ),
                  tooltip: 'Delete',
                  onPressed: transferInProgress
                      ? null
                      : () => _confirmDelete(context),
                ),
              ],
            ),
      onTap: file.isDirectory
          ? () => bloc.add(BrowserEvent.openFolder(file.name))
          : null,
    );
  }
}
