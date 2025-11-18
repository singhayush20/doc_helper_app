part of 'doc_upload_bloc.dart';

@freezed
sealed class DocUploadState extends BaseState with _$DocUploadState {
  const DocUploadState._();

  const factory DocUploadState.initial({
    required DocUploadStateStore store,
  }) = Initial;

  const factory DocUploadState.uploadInProgress({
    required DocUploadStateStore store,
  }) = UploadInProgress;

  const factory DocUploadState.onUploadSuccess({
    required DocUploadStateStore store,
  }) = OnUploadSuccess;

  const factory DocUploadState.onUploadCancel({
    required DocUploadStateStore store,
  }) = OnUploadCancel;

  const factory DocUploadState.invalidateLoader({
    required DocUploadStateStore store,
  }) = InvalidateLoader;

  const factory DocUploadState.onException({
    required DocUploadStateStore store,
    required Exception exception,
  }) = OnException;

  @override
  BaseState getExceptionState(Exception exception) =>
      DocUploadState.onException(store: store, exception: exception);

  @override
  BaseState getLoaderState({required bool loading}) =>
      DocUploadState.invalidateLoader(
        store: store.copyWith(
          isUploading: loading,
        ),
      );
}

@liteFreezed
sealed class DocUploadStateStore with _$DocUploadStateStore {
  const factory DocUploadStateStore({
    required double progress,
    required bool isUploading,
    required String fileName,
    FileUploadResponse? uploadResponse,
    String? errorMessage,
    @Default(false) bool loading,
  }) = _DocUploadStateStore;
}
