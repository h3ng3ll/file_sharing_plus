import 'package:flutter/material.dart';

import 'colors/app_colors.dart';
import 'text/app_text_style.dart';

/// Provides the application's [ThemeData].
abstract final class AppThemeData {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background.value,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary.value,
          primary: AppColors.primary.value,
          surface: AppColors.surface.value,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.surface.value,
          foregroundColor: AppColors.textPrimary.value,
          elevation: 0.0,
          centerTitle: false,
          titleTextStyle: AppTextStyle.semibold18.value.copyWith(
            color: AppColors.textPrimary.value,
          ),
        ),
        dividerTheme: DividerThemeData(
          color: AppColors.divider.value,
          thickness: 1.0,
          space: 1.0,
        ),
      );
}
