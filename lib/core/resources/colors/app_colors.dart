import 'package:flutter/material.dart';

/// Central palette for the application.
///
/// Access a color through its [value], e.g. `AppColors.primary.value`.
/// Never hardcode raw [Color] literals inside widgets.
enum AppColors {
  primary(Color(0xFF2F6FED)),
  primaryDark(Color(0xFF1B4FBF)),
  accent(Color(0xFF34D399)),
  danger(Color(0xFFE53935)),
  warning(Color(0xFFF59E0B)),

  background(Color(0xFFF5F6FA)),
  surface(Color(0xFFFFFFFF)),
  divider(Color(0xFFE2E5EC)),

  textPrimary(Color(0xFF1A1C20)),
  textSecondary(Color(0xFF6B7280)),
  onPrimary(Color(0xFFFFFFFF)),

  disabled(Color(0xFFBDBDBD)),
  white(Color(0xFFFFFFFF)),
  black(Color(0xFF000000)),
  transparent(Color(0x00000000));

  final Color value;

  const AppColors(this.value);
}
