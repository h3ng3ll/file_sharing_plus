import 'package:flutter/material.dart';

import '../resources/colors/app_colors.dart';
import '../resources/text/app_text_style.dart';

/// A titled surface card used to group related content into sections.
class SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;

  const SectionCard({
    super.key,
    required this.title,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface.value,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: AppColors.divider.value),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyle.semibold16.value.copyWith(
                    color: AppColors.textPrimary.value,
                  ),
                ),
              ),
              ?trailing,
            ],
          ),
          const SizedBox(height: 12.0),
          child,
        ],
      ),
    );
  }
}
