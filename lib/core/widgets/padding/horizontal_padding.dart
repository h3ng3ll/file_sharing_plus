import 'package:flutter/material.dart';

/// Standard horizontal inset sizes used across the app.
enum HorizontalPaddingSize {
  small,
  medium,
  big,
}

/// Wraps [child] in a consistent horizontal padding.
class HorizontalPadding extends StatelessWidget {
  final Widget child;
  final HorizontalPaddingSize size;

  const HorizontalPadding({
    super.key,
    required this.child,
    this.size = HorizontalPaddingSize.medium,
  });

  double get _value {
    switch (size) {
      case HorizontalPaddingSize.small:
        return 8.0;
      case HorizontalPaddingSize.medium:
        return 16.0;
      case HorizontalPaddingSize.big:
        return 32.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _value),
      child: child,
    );
  }
}
