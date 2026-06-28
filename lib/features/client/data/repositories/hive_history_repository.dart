import 'package:hive_ce/hive.dart';

import '../../domain/models/transfer_record.dart';
import '../../domain/repositories/i_history_repository.dart';

/// Hive-backed [IHistoryRepository].
///
/// The opened [Box] is injected, so the repository owns no Hive setup/teardown.
class HiveHistoryRepository implements IHistoryRepository {
  final Box<TransferRecord> _box;

  HiveHistoryRepository({required Box<TransferRecord> box}) : _box = box;

  @override
  List<TransferRecord> getAll() => _box.values.toList().reversed.toList();

  @override
  Stream<List<TransferRecord>> watch() async* {
    yield getAll();
    yield* _box.watch().map((_) => getAll());
  }

  @override
  Future<void> add(TransferRecord record) => _box.add(record);

  @override
  Future<void> clear() => _box.clear();
}
