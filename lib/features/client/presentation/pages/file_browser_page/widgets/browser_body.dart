import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/browser_bloc/browser_bloc.dart';
import 'file_list.dart';
import 'path_bar.dart';
import 'transfer_history_list.dart';
import 'transfer_progress_tile.dart';

/// Composes the file browser: path bar, file list, live progress and history.
class BrowserBody extends StatelessWidget {
  const BrowserBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BrowserBloc, BrowserState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const PathBar(),
            if (state.progress != null) const TransferProgressTile(),
            const Expanded(child: FileList()),
            if (state.history.isNotEmpty) const TransferHistoryList(),
          ],
        );
      },
    );
  }
}
