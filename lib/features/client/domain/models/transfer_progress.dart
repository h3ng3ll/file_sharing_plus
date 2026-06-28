import 'package:freezed_annotation/freezed_annotation.dart';

part 'transfer_progress.freezed.dart';

/// Direction of an in-flight transfer.
enum TransferDirection { download, upload }

/// Progress of a single file transfer, emitted as bytes move.
@freezed
sealed class TransferProgress with _$TransferProgress {
  const TransferProgress._();

  const factory TransferProgress({
    required String fileName,
    required TransferDirection direction,
    required int transferred,
    required int total,
  }) = _TransferProgress;

  /// Completion ratio in the range `0.0`–`1.0`, or `null` when the total size
  /// is unknown (renders an indeterminate bar).
  double? get ratio {
    if (total <= 0) return null;
    return (transferred / total).clamp(0.0, 1.0);
  }

  bool get isComplete => total > 0 && transferred >= total;
}
