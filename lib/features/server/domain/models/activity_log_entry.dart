import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_log_entry.freezed.dart';

/// Kind of activity recorded in the server log.
enum ActivityType {
  serverStarted,
  serverStopped,
  connection,
  download,
  upload,
  delete,
  error,
}

/// A single line in the server's activity log.
@freezed
sealed class ActivityLogEntry with _$ActivityLogEntry {
  const factory ActivityLogEntry({
    required ActivityType type,
    required String message,
    required DateTime timestamp,
  }) = _ActivityLogEntry;
}
