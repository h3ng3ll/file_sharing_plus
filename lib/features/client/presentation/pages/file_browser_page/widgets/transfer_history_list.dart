import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/resources/colors/app_colors.dart';
import '../../../../../../core/resources/text/app_text_style.dart';
import '../../../../domain/models/transfer_progress.dart';
import '../../../bloc/browser_bloc/browser_bloc.dart';

/// Compact, scrollable list of completed transfers (newest first).
class TransferHistoryList extends StatelessWidget {
  const TransferHistoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BrowserBloc, BrowserState>(
      buildWhen: (p, c) => p.history != c.history,
      builder: (context, state) {
        return Container(
          constraints: const BoxConstraints(maxHeight: 160.0),
          decoration: BoxDecoration(
            color: AppColors.surface.value,
            border: Border(
              top: BorderSide(color: AppColors.divider.value),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'Transfer History',
                  style: AppTextStyle.semibold16.value,
                ),
              ),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: state.history.length,
                  itemBuilder: (context, index) {
                    final record = state.history[index];
                    final isDownload =
                        record.direction == TransferDirection.download;
                    return ListTile(
                      dense: true,
                      leading: Icon(
                        isDownload ? Icons.download_done : Icons.upload_file,
                        size: 18.0,
                        color: record.success
                            ? AppColors.accent.value
                            : AppColors.danger.value,
                      ),
                      title: Text(
                        record.fileName,
                        style: AppTextStyle.regular14.value,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Text(
                        record.success ? 'Done' : 'Failed',
                        style: AppTextStyle.regular12.value.copyWith(
                          color: record.success
                              ? AppColors.accent.value
                              : AppColors.danger.value,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
