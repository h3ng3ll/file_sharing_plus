import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';

import 'transfer_progress.dart';

part 'transfer_record.freezed.dart';

/// A finished (or failed) transfer, kept for the history list.
///
/// Persisted in Hive; the adapter is generated centrally via `@GenerateAdapters`
/// in `core/hive/hive_adapters.dart`.
@freezed
sealed class TransferRecord extends HiveObject with _$TransferRecord {
  TransferRecord._();

  factory TransferRecord({
    required String fileName,
    required TransferDirection direction,
    required bool success,
    required DateTime timestamp,

    /// Local path of a downloaded file (used to offer "Save to Files").
    String? savedPath,
  }) = _TransferRecord;
}
