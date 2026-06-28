import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/resources/colors/app_colors.dart';
import '../../../../../../core/resources/text/app_text_style.dart';
import '../../../../../../core/utils/extensions/int_size_x.dart';
import '../../../../../../core/widgets/section_card.dart';
import '../../../bloc/server_bloc/server_bloc.dart';

/// Lists the files inside the shared folder.
class SharedFilesList extends StatelessWidget {
  const SharedFilesList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServerBloc, ServerState>(
      builder: (context, state) {
        return SectionCard(
          title: 'Shared Files (${state.files.length})',
          trailing: IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: state.hasSharedFolder
                ? () => context
                    .read<ServerBloc>()
                    .add(const ServerEvent.refreshFiles())
                : null,
          ),
          child: state.files.isEmpty
              ? Text(
                  state.hasSharedFolder
                      ? 'Folder is empty'
                      : 'Select a folder to share',
                  style: AppTextStyle.regular14.value.copyWith(
                    color: AppColors.textSecondary.value,
                  ),
                )
              : Column(
                  children: state.files
                      .map(
                        (file) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            file.isDirectory
                                ? Icons.folder
                                : Icons.insert_drive_file,
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
                        ),
                      )
                      .toList(),
                ),
        );
      },
    );
  }
}
