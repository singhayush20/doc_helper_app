part of 'doc_upload_bloc.dart';

@freezed
sealed class DocUploadEvent extends BaseEvent with _$DocUploadEvent {
  const DocUploadEvent._() : super();

  const factory DocUploadEvent.started() = _Started;

  const factory DocUploadEvent.fileSelected(String filePath) = _FileSelected;

  const factory DocUploadEvent.uploadRequested() = _UploadRequested;

  const factory DocUploadEvent.uploadCancelled() = _UploadCancelled;

  const factory DocUploadEvent.uploadProgressUpdated({
    required double progress,
  }) = _UploadProgressUpdated;

  const factory DocUploadEvent.onUploadProgressError() = _OnUploadProgressError;

  const factory DocUploadEvent.uploadCompleted() = _UploadCompleted;
}
