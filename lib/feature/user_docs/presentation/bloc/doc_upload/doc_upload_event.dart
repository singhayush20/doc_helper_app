part of 'doc_upload_bloc.dart';

@freezed
sealed class DocUploadEvent extends BaseEvent with _$DocUploadEvent {
  const DocUploadEvent._() : super();

  const factory DocUploadEvent.started() = _Started;

  /// Triggered when user picks a file from device
  const factory DocUploadEvent.fileSelected(String filePath) = _FileSelected;

  /// Triggered when user taps ❌
  const factory DocUploadEvent.uploadCancelled() = _UploadCancelled;
}
