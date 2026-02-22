part of 'summary_bloc.dart';

@freezed
sealed class SummaryEvent extends BaseEvent with _$SummaryEvent {
  const SummaryEvent._() : super();

  const factory SummaryEvent.started({
    required int? documentId,
    required SummaryTone? tone,
    required SummaryLength? length,
  }) = _Started;

  const factory SummaryEvent.onSummaryIndexChanged({
    required int index,
  }) = _OnSummaryIndexChanged;

  const factory SummaryEvent.onSummarySettingsDialogRequested() =
      _OnSummarySettingsDialogRequested;
}
