import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/models/transfer_record.dart';
import '../../../domain/repositories/i_history_repository.dart';

part 'history_event.dart';
part 'history_state.dart';
part 'history_bloc.freezed.dart';

/// Exposes the persisted transfer history, kept live via the repository stream.
class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final IHistoryRepository _historyRepository;

  HistoryBloc({
    required IHistoryRepository historyRepository,
  })  : _historyRepository = historyRepository,
        super(const HistoryState()) {
    on<_Started>(_started);
  }

  Future<void> _started(_Started event, Emitter<HistoryState> emit) async {
    await emit.forEach<List<TransferRecord>>(
      _historyRepository.watch(),
      onData: (records) => state.copyWith(
        status: HistoryStatus.loaded,
        records: records,
      ),
      onError: (_, _) => state.copyWith(status: HistoryStatus.loaded),
    );
  }
}
