import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/resources/colors/app_colors.dart';
import '../../../../../../core/resources/text/app_text_style.dart';
import '../../../../../../core/widgets/section_card.dart';
import '../../../../domain/models/activity_log_entry.dart';
import '../../../bloc/server_bloc/server_bloc.dart';

/// Scrolling list of server activity, newest first.
class ActivityLogList extends StatelessWidget {
  const ActivityLogList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServerBloc, ServerState>(
      builder: (context, state) {
        return SectionCard(
          title: 'Activity Log',
          child: state.log.isEmpty
              ? Text(
                  'No activity yet',
                  style: AppTextStyle.regular14.value.copyWith(
                    color: AppColors.textSecondary.value,
                  ),
                )
              : Column(
                  children: state.log
                      .map((entry) => _LogTile(entry: entry))
                      .toList(),
                ),
        );
      },
    );
  }
}

class _LogTile extends StatelessWidget {
  final ActivityLogEntry entry;

  const _LogTile({required this.entry});

  @override
  Widget build(BuildContext context) {
    final time = entry.timestamp;
    final stamp = '${_two(time.hour)}:${_two(time.minute)}:${_two(time.second)}';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            _iconFor(entry.type),
            size: 16.0,
            color: _colorFor(entry.type),
          ),
          const SizedBox(width: 8.0),
          Text(
            stamp,
            style: AppTextStyle.regular12.value.copyWith(
              color: AppColors.textSecondary.value,
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              entry.message,
              style: AppTextStyle.regular12.value,
            ),
          ),
        ],
      ),
    );
  }

  String _two(int v) => v.toString().padLeft(2, '0');

  IconData _iconFor(ActivityType type) {
    switch (type) {
      case ActivityType.serverStarted:
        return Icons.play_circle;
      case ActivityType.serverStopped:
        return Icons.stop_circle;
      case ActivityType.connection:
        return Icons.link;
      case ActivityType.download:
        return Icons.download;
      case ActivityType.upload:
        return Icons.upload;
      case ActivityType.delete:
        return Icons.delete;
      case ActivityType.error:
        return Icons.error_outline;
    }
  }

  Color _colorFor(ActivityType type) {
    switch (type) {
      case ActivityType.error:
      case ActivityType.delete:
        return AppColors.danger.value;
      case ActivityType.serverStarted:
      case ActivityType.download:
      case ActivityType.upload:
        return AppColors.accent.value;
      default:
        return AppColors.textSecondary.value;
    }
  }
}
