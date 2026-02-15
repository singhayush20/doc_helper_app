part of 'doc_summarizer_bloc.dart';

@freezed
sealed class DocSummarizerEvent extends BaseEvent with _$DocSummarizerEvent {
  const DocSummarizerEvent._() : super();

  const factory DocSummarizerEvent.started() = _Started;

  const factory DocSummarizerEvent.uploadDocument() = _UploadDocument;
}