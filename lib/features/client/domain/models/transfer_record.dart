import 'package:freezed_annotation/freezed_annotation.dart';

import 'transfer_progress.dart';

part 'transfer_record.freezed.dart';

/// A finished (or failed) transfer, kept for the history list.
@freezed
sealed class TransferRecord with _$TransferRecord {
  const factory TransferRecord({
    required String fileName,
    required TransferDirection direction,
    required bool success,
    required DateTime timestamp,
  }) = _TransferRecord;
}
