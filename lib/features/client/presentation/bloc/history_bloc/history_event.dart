part of 'history_bloc.dart';

@freezed
sealed class HistoryEvent with _$HistoryEvent {
  /// Begins watching the persisted history.
  const factory HistoryEvent.started() = _Started;
}
