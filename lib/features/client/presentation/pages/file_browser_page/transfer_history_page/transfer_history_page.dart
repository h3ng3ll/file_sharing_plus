import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/resources/colors/app_colors.dart';
import '../../../../../../core/resources/text/app_text_style.dart';
import '../../../../../../core/services/file_share_service.dart';
import '../../../../../../core/widgets/custom_app_bar.dart';
import '../../../../domain/models/transfer_progress.dart';
import '../../../../domain/models/transfer_record.dart';
import '../../../bloc/history_bloc/history_bloc.dart';

/// Full-screen list of persisted transfers (newest first).
///
/// Reads [HistoryBloc] provided by the client shell route, so it shows the
/// Hive-backed history. Successful downloads are tappable to re-open the iOS
/// "Save to Files" sheet.
class TransferHistoryPage extends StatelessWidget {
  const TransferHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Transfer History'),
      body: BlocBuilder<HistoryBloc, HistoryState>(
        buildWhen: (p, c) => p.records != c.records,
        builder: (context, state) {
          if (state.records.isEmpty) {
            return Center(
              child: Text(
                'No transfers yet',
                style: AppTextStyle.regular16.value.copyWith(
                  color: AppColors.textSecondary.value,
                ),
              ),
            );
          }
          return ListView.separated(
            itemCount: state.records.length,
            separatorBuilder: (_, _) => const Divider(height: 1.0),
            itemBuilder: (context, index) =>
                _HistoryTile(record: state.records[index]),
          );
        },
      ),
    );
  }
}

/// A single transfer row; tappable to re-share when it is a saved download.
class _HistoryTile extends StatelessWidget {
  final TransferRecord record;

  const _HistoryTile({required this.record});

  bool get _isDownload => record.direction == TransferDirection.download;

  bool get _canShare =>
      _isDownload && record.success && record.savedPath != null;

  String get _timestamp {
    final t = record.timestamp;
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(t.hour)}:${two(t.minute)}:${two(t.second)}';
  }

  @override
  Widget build(BuildContext context) {
    final statusColor =
        record.success ? AppColors.accent.value : AppColors.danger.value;

    return ListTile(
      leading: Icon(
        _isDownload ? Icons.download_done : Icons.upload_file,
        color: statusColor,
      ),
      title: Text(
        record.fileName,
        style: AppTextStyle.regular14.value,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${_isDownload ? 'Download' : 'Upload'} · $_timestamp',
        style: AppTextStyle.regular12.value.copyWith(
          color: AppColors.textSecondary.value,
        ),
      ),
      trailing: _canShare
          ? Icon(Icons.ios_share, color: AppColors.primary.value)
          : Text(
              record.success ? 'Done' : 'Failed',
              style: AppTextStyle.regular12.value.copyWith(color: statusColor),
            ),
      onTap: _canShare
          ? () => FileShareService.saveFile(
                record.savedPath!,
                subject: record.fileName,
              )
          : null,
    );
  }
}
