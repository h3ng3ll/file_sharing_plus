import 'package:freezed_annotation/freezed_annotation.dart';

part 'file_entry.freezed.dart';
part 'file_entry.g.dart';

/// A file or folder entry as exposed over the HTTP API.
///
/// Shared between the server (which produces the `/files` JSON) and the client
/// (which consumes it), so the wire format has a single source of truth.
@freezed
sealed class FileEntry with _$FileEntry {
  const factory FileEntry({
    required String name,
    required bool isDirectory,
    @Default(0) int size,
  }) = _FileEntry;

  factory FileEntry.fromJson(Map<String, dynamic> json) =>
      _$FileEntryFromJson(json);
}
