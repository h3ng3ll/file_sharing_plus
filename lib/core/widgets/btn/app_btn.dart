import 'package:flutter/material.dart';

import '../../resources/colors/app_colors.dart';
import '../../resources/text/app_text_style.dart';

/// Primary filled button used across the app.
class PrimaryBtn extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData? icon;
  final double? width;
  final Color? color;

  const PrimaryBtn({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.width,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;
    final background =
        isEnabled ? (color ?? AppColors.primary.value) : AppColors.disabled.value;

    return SizedBox(
      width: width,
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(12.0),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 14.0,
              horizontal: 20.0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    color: AppColors.onPrimary.value,
                    size: 20.0,
                  ),
                  const SizedBox(width: 8.0),
                ],
                Text(
                  text,
                  style: AppTextStyle.semibold16.value.copyWith(
                    color: AppColors.onPrimary.value,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
