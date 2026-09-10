import 'package:flutter/widgets.dart';
import 'package:share_plus/share_plus.dart';

/// Presents the native share / "Save to Files" sheet for a local file.
///
/// Static-only utility (mirrors [UiMessageService]'s style). On iOS the sheet
/// includes "Save to Files", letting the user place a downloaded file wherever
/// they can find it (iCloud Drive, On My iPhone, …).
final class FileShareService {
  const FileShareService._();

  /// Fallback anchor used when [context] cannot yield a laid-out box.
  ///
  /// iPad presents the sheet as a popover anchored to this rect and rejects a
  /// zero-sized one, so a small non-empty rect is used rather than [Rect.zero].
  static const Rect _fallbackOrigin = Rect.fromLTWH(0.0, 0.0, 1.0, 1.0);

  /// Opens the share sheet for the file at [path].
  ///
  /// [context] anchors the sheet: iPadOS presents it as a popover and rejects a
  /// zero-sized `sourceRect`, throwing a `PlatformException`. Passing no origin
  /// at all makes the plugin omit the rect entirely, which the iOS side reads
  /// as `CGRectZero` — the same failure.
  ///
  /// Never throws: the sheet is a best-effort convenience, and the file is
  /// already safely on disk by the time it is offered. Failures are reported
  /// through [onError] so the caller can surface them without crashing.
  static Future<void> saveFile(
    BuildContext context,
    String path, {
    String? subject,
    ValueChanged<Object>? onError,
  }) async {
    final origin = _originFrom(context);

    try {
      await Share.shareXFiles(
        [XFile(path)],
        subject: subject,
        sharePositionOrigin: origin,
      );
    } catch (error, stackTrace) {
      debugPrint('FileShareService.saveFile failed for $path: $error');
      debugPrintStack(stackTrace: stackTrace);
      onError?.call(error);
    }
  }

  /// Global-coordinate rect of [context]'s render box, or [_fallbackOrigin].
  static Rect _originFrom(BuildContext context) {
    if (!context.mounted) return _fallbackOrigin;

    final box = context.findRenderObject();

    if (box is! RenderBox || !box.hasSize || box.size.isEmpty) {
      return _fallbackOrigin;
    }

    return box.localToGlobal(Offset.zero) & box.size;
  }
}
