import 'package:flutter/material.dart';

import 'file_list.dart';
import 'path_bar.dart';

/// Composes the file browser: path bar above the scrollable file list.
///
/// Live transfer progress is shown as a centered overlay by the page, and the
/// transfer history lives on its own screen reached from the app bar — neither
/// is rendered inline here, keeping the bottom safe area clear.
class BrowserBody extends StatelessWidget {
  const BrowserBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PathBar(),
        Expanded(child: FileList()),
      ],
    );
  }
}
