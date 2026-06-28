import 'package:flutter/material.dart';

/// Application text styles.
///
/// Access a style through its [value], e.g. `AppTextStyle.regular14.value`.
/// Never construct raw [TextStyle] literals inside widgets.
enum AppTextStyle {
  regular12(
    TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.w400,
    ),
  ),
  regular14(
    TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w400,
    ),
  ),
  regular16(
    TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
    ),
  ),
  medium14(
    TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
    ),
  ),
  medium16(
    TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
    ),
  ),
  semibold16(
    TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
    ),
  ),
  semibold18(
    TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
    ),
  ),
  bold20(
    TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.w700,
    ),
  ),
  bold24(
    TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.w700,
    ),
  );

  final TextStyle value;

  const AppTextStyle(this.value);
}
