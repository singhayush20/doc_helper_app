part of 'doc_summarizer_bloc.dart';

@freezed
sealed class DocSummarizerEvent extends BaseEvent with _$DocSummarizerEvent {
  const DocSummarizerEvent._() : super();

  const factory DocSummarizerEvent.started() = _Started;

  const factory DocSummarizerEvent.uploadDocument() = _UploadDocument;

  const factory DocSummarizerEvent.onViewAllPressed() = _OnViewAllPressed;

  const factory DocSummarizerEvent.summaryToneChanged(SummaryTone tone) =
      _SummaryToneChanged;

  const factory DocSummarizerEvent.summaryLengthChanged(SummaryLength length) =
      _SummaryLengthChanged;

  const factory DocSummarizerEvent.onDocumentPressed({
    required int? documentId,
  }) = _OnDocumentPressed;
}
