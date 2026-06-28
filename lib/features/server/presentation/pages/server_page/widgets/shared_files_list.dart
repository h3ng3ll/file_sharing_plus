import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/resources/colors/app_colors.dart';
import '../../../../../../core/resources/text/app_text_style.dart';
import '../../../../../../core/widgets/section_card.dart';
import '../../../bloc/server_bloc/server_bloc.dart';
import 'shared_file_tile.dart';

/// Minimum width for a single file row; columns fit as many of these as the
/// card allows, capped at two.
const double _minTileWidth = 280.0;

/// Horizontal gap between file columns.
const double _columnSpacing = 16.0;

/// Fixed height of the scrollable file area, so the card stays bounded no
/// matter how many files the shared folder contains.
const double _listHeight = 360.0;

/// Lists the files inside the shared folder, reflowing into up to two columns.
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
              : SizedBox(
                  height: _listHeight,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final columns = (constraints.maxWidth / _minTileWidth)
                          .floor()
                          .clamp(1, 2);
                      final tileWidth = columns == 1
                          ? constraints.maxWidth
                          : (constraints.maxWidth -
                                  _columnSpacing * (columns - 1)) /
                              columns;
                      return SingleChildScrollView(
                        child: Wrap(
                          spacing: _columnSpacing,
                          children: state.files
                              .map(
                                (file) => SizedBox(
                                  width: tileWidth,
                                  child: SharedFileTile(file: file),
                                ),
                              )
                              .toList(),
                        ),
                      );
                    },
                  ),
                ),
        );
      },
    );
  }
}
