import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/resources/colors/app_colors.dart';
import '../../../bloc/browser_bloc/browser_bloc.dart';

/// Floating action button that picks a file and uploads it to the server.
class UploadButton extends StatelessWidget {
  const UploadButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BrowserBloc, BrowserState>(
      buildWhen: (p, c) => p.isTransferring != c.isTransferring,
      builder: (context, state) {
        return FloatingActionButton.extended(
          backgroundColor: AppColors.primary.value,
          foregroundColor: AppColors.onPrimary.value,
          icon: const Icon(Icons.upload),
          label: const Text('Upload'),
          onPressed: state.isTransferring
              ? null
              : () => context
                  .read<BrowserBloc>()
                  .add(const BrowserEvent.pickAndUpload()),
        );
      },
    );
  }
}
