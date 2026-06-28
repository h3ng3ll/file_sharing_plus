import 'package:flutter/material.dart';

import '../resources/colors/app_colors.dart';
import '../resources/text/app_text_style.dart';

/// Linear transfer-progress indicator with an optional percentage label.
///
/// [progress] is a value in the range `0.0`–`1.0`. A `null` value renders an
/// indeterminate bar (used while a transfer is starting and totals are unknown).
class ProgressBar extends StatelessWidget {
  final double? progress;
  final String? label;

  const ProgressBar({
    super.key,
    required this.progress,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final percent = progress == null ? null : (progress! * 100).clamp(0, 100);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4.0),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6.0,
            backgroundColor: AppColors.divider.value,
            valueColor: AlwaysStoppedAnimation<Color>(
              AppColors.primary.value,
            ),
          ),
        ),
        if (label != null || percent != null) ...[
          const SizedBox(height: 4.0),
          Text(
            percent == null
                ? (label ?? '')
                : '${label != null ? '$label ' : ''}${percent.toStringAsFixed(0)}%',
            style: AppTextStyle.regular12.value.copyWith(
              color: AppColors.textSecondary.value,
            ),
          ),
        ],
      ],
    );
  }
}
