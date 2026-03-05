part of 'history_bloc.dart';

@freezed
sealed class HistoryEvent extends BaseEvent with _$HistoryEvent {
  const HistoryEvent._() : super();

  const factory HistoryEvent.started() = _Started;

  const factory HistoryEvent.searchQueryChanged(String query) =
      _SearchQueryChanged;

  const factory HistoryEvent.onPageRefreshed() = _OnPageRefreshed;

  const factory HistoryEvent.onDocumentPressed({required int? documentId}) =
      _OnDocumentPressed;

  const factory HistoryEvent.onDocumentDeleted({required int? documentId}) =
      _OnDocumentDeleted;
}
