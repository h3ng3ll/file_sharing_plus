import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// Convenience navigation helpers on top of go_router.
extension GoRouterX on BuildContext {
  /// Pops the current route if possible.
  void goBack() {
    if (canPop()) {
      pop();
    }
  }
}
