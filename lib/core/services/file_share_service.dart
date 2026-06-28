import 'package:share_plus/share_plus.dart';

/// Presents the native share / "Save to Files" sheet for a local file.
///
/// Static-only utility (mirrors [UiMessageService]'s style). On iOS the sheet
/// includes "Save to Files", letting the user place a downloaded file wherever
/// they can find it (iCloud Drive, On My iPhone, …).
final class FileShareService {
  const FileShareService._();

  /// Opens the share sheet for the file at [path].
  static Future<void> saveFile(String path, {String? subject}) {
    return Share.shareXFiles(
      [XFile(path)],
      subject: subject,
    );
  }
}
