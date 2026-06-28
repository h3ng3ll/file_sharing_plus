import '../models/transfer_record.dart';

/// Persists and exposes the transfer history.
///
/// Hides the storage backend (Hive) so the presentation layer depends only on
/// this contract.
abstract interface class IHistoryRepository {
  /// All records, newest first.
  List<TransferRecord> getAll();

  /// Emits the full record list (newest first) on every change.
  Stream<List<TransferRecord>> watch();

  /// Appends a finished-transfer [record].
  Future<void> add(TransferRecord record);

  /// Removes all history.
  Future<void> clear();
}
