import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;

/// Streaming parser for a single-file `multipart/form-data` upload.
///
/// Designed for arbitrarily large files: the request body is consumed chunk by
/// chunk and written straight to disk via [File.openWrite]. Only a small
/// boundary-sized window is ever held in memory.
abstract final class MultipartParser {
  /// Reads the first file part from [request] and writes it to the path
  /// returned by [destinationResolver]. Returns the saved file name, or `null`
  /// if no file part was found.
  static Future<String?> streamFileToDisk({
    required HttpRequest request,
    required String boundary,
    required String Function(String fileName) destinationResolver,
  }) async {
    final delimiter = utf8.encode('--$boundary');
    final crlf = utf8.encode('\r\n');

    final buffer = BytesBuilder(copy: false);
    var headersParsed = false;
    String? fileName;
    IOSink? sink;

    // Bytes carried over between chunks so a boundary split across two chunks
    // is still detected.
    var pending = Uint8List(0);

    Future<void> closeSink() async {
      if (sink != null) {
        await sink!.flush();
        await sink!.close();
        sink = null;
      }
    }

    try {
      await for (final chunk in request) {
        var data = _concat(pending, chunk);
        pending = Uint8List(0);

        if (!headersParsed) {
          // Accumulate until we have the part headers (terminated by a blank
          // line: \r\n\r\n).
          buffer.add(data);
          final accumulated = buffer.toBytes();
          final headerEnd = _indexOf(accumulated, utf8.encode('\r\n\r\n'));
          if (headerEnd == -1) {
            continue;
          }

          final header = utf8.decode(
            accumulated.sublist(0, headerEnd),
            allowMalformed: true,
          );
          fileName = _extractFileName(header) ?? 'upload.bin';
          final dest = destinationResolver(p.basename(fileName));
          sink = File(dest).openWrite();
          headersParsed = true;

          // Everything after the header block is body data.
          data = accumulated.sublist(headerEnd + 4);
        }

        // Look for the closing boundary within the body stream.
        final boundaryIndex = _indexOf(data, _concat(crlf, delimiter));
        if (boundaryIndex != -1) {
          sink!.add(data.sublist(0, boundaryIndex));
          await closeSink();
          // Drain the rest of the request without writing it.
          break;
        }

        // Hold back a tail the size of the boundary in case it is split across
        // the chunk boundary.
        final keep = crlf.length + delimiter.length;
        if (data.length > keep) {
          sink!.add(data.sublist(0, data.length - keep));
          pending = Uint8List.fromList(data.sublist(data.length - keep));
        } else {
          pending = Uint8List.fromList(data);
        }
      }

      // Flush any trailing bytes that were never followed by a boundary.
      if (sink != null && pending.isNotEmpty) {
        final boundaryIndex = _indexOf(pending, _concat(crlf, delimiter));
        if (boundaryIndex != -1) {
          sink!.add(pending.sublist(0, boundaryIndex));
        } else {
          sink!.add(pending);
        }
      }
      await closeSink();
      return fileName == null ? null : p.basename(fileName);
    } catch (e) {
      await closeSink();
      rethrow;
    }
  }

  static Uint8List _concat(Uint8List a, Uint8List b) {
    final result = Uint8List(a.length + b.length);
    result.setRange(0, a.length, a);
    result.setRange(a.length, result.length, b);
    return result;
  }

  /// Returns the index of [needle] in [haystack], or -1.
  static int _indexOf(Uint8List haystack, List<int> needle) {
    if (needle.isEmpty || haystack.length < needle.length) return -1;
    for (var i = 0; i <= haystack.length - needle.length; i++) {
      var match = true;
      for (var j = 0; j < needle.length; j++) {
        if (haystack[i + j] != needle[j]) {
          match = false;
          break;
        }
      }
      if (match) return i;
    }
    return -1;
  }

  static String? _extractFileName(String header) {
    final match = RegExp('filename="([^"]*)"').firstMatch(header);
    return match?.group(1);
  }
}
