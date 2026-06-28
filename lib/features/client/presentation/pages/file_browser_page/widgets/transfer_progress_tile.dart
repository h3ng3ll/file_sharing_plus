import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/resources/colors/app_colors.dart';
import '../../../../../../core/resources/text/app_text_style.dart';
import '../../../../../../core/widgets/progress_bar.dart';
import '../../../../domain/models/transfer_progress.dart';
import '../../../bloc/browser_bloc/browser_bloc.dart';

/// Shows the in-flight transfer's name, direction and progress bar.
class TransferProgressTile extends StatelessWidget {
  const TransferProgressTile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BrowserBloc, BrowserState>(
      buildWhen: (p, c) => p.progress != c.progress,
      builder: (context, state) {
        final progress = state.progress;
        if (progress == null) return const SizedBox.shrink();

        final isDownload =
            progress.direction == TransferDirection.download;
        return Container(
          color: AppColors.surface.value,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(
                    isDownload ? Icons.download : Icons.upload,
                    size: 18.0,
                    color: AppColors.primary.value,
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      progress.fileName,
                      style: AppTextStyle.medium14.value,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              ProgressBar(
                progress: progress.ratio,
                label: isDownload ? 'Downloading' : 'Uploading',
              ),
            ],
          ),
        );
      },
    );
  }
}
