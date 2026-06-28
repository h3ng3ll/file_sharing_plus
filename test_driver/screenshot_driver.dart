import 'dart:io';

import 'package:integration_test/integration_test_driver_extended.dart';

/// Test driver for the screenshot harness.
///
/// `integration_test`'s `takeScreenshot(name)` sends the captured bytes here;
/// this writes each to `screenshots/<platform>/<name>.png`. The platform folder
/// is derived from the device the test ran on, passed through the screenshot
/// name when needed, but defaults by the host running the test:
/// macOS shots come from `-d macos`, iOS shots from a simulator.
Future<void> main() async {
  await integrationDriver(
    onScreenshot: (String name, List<int> bytes, [Map<String, Object?>? args]) async {
      // Names are prefixed `server-` (macOS) or `client-` (iOS); route the file
      // into the matching platform folder.
      final platform = name.startsWith('server-') ? 'macos' : 'ios';
      final dir = Directory('screenshots/$platform');
      await dir.create(recursive: true);
      final file = File('${dir.path}/$name.png');
      await file.writeAsBytes(bytes);
      // Returning true tells the harness the screenshot was handled.
      return true;
    },
  );
}
