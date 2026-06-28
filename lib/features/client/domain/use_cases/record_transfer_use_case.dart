import '../models/transfer_record.dart';
import '../repositories/i_history_repository.dart';

/// Appends a finished transfer to the persisted history.
class RecordTransferUseCase {
  final IHistoryRepository _historyRepository;

  const RecordTransferUseCase({
    required IHistoryRepository historyRepository,
  }) : _historyRepository = historyRepository;

  Future<void> call(TransferRecord record) =>
      _historyRepository.add(record);
}
