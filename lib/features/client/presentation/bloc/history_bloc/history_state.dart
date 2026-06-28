part of 'history_bloc.dart';

enum HistoryStatus {
  initial,
  loaded,
}

extension HistoryStateX on HistoryState {
  bool get isEmpty => records.isEmpty;
}

@freezed
sealed class HistoryState with _$HistoryState {
  const factory HistoryState({
    @Default(HistoryStatus.initial) HistoryStatus status,
    @Default(<TransferRecord>[]) List<TransferRecord> records,
  }) = _HistoryState;
}
