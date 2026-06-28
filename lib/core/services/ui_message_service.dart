import 'package:flutter/material.dart';

import '../resources/colors/app_colors.dart';
import '../resources/text/app_text_style.dart';

/// Shows transient, non-blocking messages (SnackBars) to the user.
///
/// Backed by a global [ScaffoldMessengerState] so messages can be shown from
/// anywhere (blocs, listeners) regardless of the current route, and on every
/// platform (macOS + iOS) without a native plugin. Attach [messengerKey] to
/// `MaterialApp.scaffoldMessengerKey`.
///
/// Static-only utility — call directly, e.g. `UiMessageService.showError(msg)`,
/// typically from a `BlocListener` reacting to a failure/success state.
final class UiMessageService {
  const UiMessageService._();

  /// Global key attached to the app's [MaterialApp.scaffoldMessengerKey].
  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  /// Shows an error message (red).
  static void showError(
    String message, {
    int timeInSecondsDuration = 5,
  }) =>
      _show(message, AppColors.danger.value, timeInSecondsDuration);

  /// Shows a success message (green).
  static void showSuccess(
    String message, {
    int timeInSecondsDuration = 3,
  }) =>
      _show(message, AppColors.accent.value, timeInSecondsDuration);

  /// Shows a neutral informational message.
  static void showInfo(
    String message, {
    int timeInSecondsDuration = 3,
  }) =>
      _show(message, AppColors.black.value, timeInSecondsDuration);

  static void _show(String message, Color background, int seconds) {
    if (message.isEmpty) return;
    final messenger = messengerKey.currentState;
    if (messenger == null) return;

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: AppTextStyle.regular14.value.copyWith(
              color: AppColors.white.value,
            ),
          ),
          backgroundColor: background,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: seconds),
        ),
      );
  }
}
