import 'package:file_sharing/core/utils/extensions/int_size_x.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('IntSizeX.readableSize', () {
    test('formats bytes', () {
      expect(512.readableSize, '512 B');
    });

    test('formats kilobytes', () {
      expect(2048.readableSize, '2.0 KB');
    });

    test('formats megabytes', () {
      expect((5 * 1024 * 1024).readableSize, '5.0 MB');
    });
  });
}
