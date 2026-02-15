part of 'doc_summarizer_bloc.dart';

@freezed
sealed class DocSummarizerState extends BaseState with _$DocSummarizerState {
  const DocSummarizerState._();

  const factory DocSummarizerState.initial({
    required DocSummarizerStateStore store,
  }) = Initial;

  const factory DocSummarizerState.invalidateLoader({
    required DocSummarizerStateStore store,
  }) = InvalidateLoader;

  const factory DocSummarizerState.onException({
    required DocSummarizerStateStore store,
    required Exception exception,
  }) = OnException;

  const factory DocSummarizerState.onUploadProgress({
    required DocSummarizerStateStore store,
  }) = OnUploadProgress;

  const factory DocSummarizerState.onUploadSuccess({
    required DocSummarizerStateStore store,
  }) = OnUploadSuccess;

  const factory DocSummarizerState.onValidationError({
    required DocSummarizerStateStore store,
  }) = OnValidationError;

  @override
  BaseState getExceptionState(Exception exception) =>
      DocSummarizerState.onException(
        store: store.copyWith(loading: false, uploading: false),
        exception: exception,
      );

  @override
  BaseState getLoaderState({required bool loading}) =>
      DocSummarizerState.invalidateLoader(
        store: store.copyWith(loading: loading),
      );
}

@liteFreezed
sealed class DocSummarizerStateStore with _$DocSummarizerStateStore {
  const factory DocSummarizerStateStore({
    @Default(false) bool loading,
    @Default(false) bool uploading,
    String? uploadProgressMessage,
    String? validationErrorMessage,
    DocumentUploadResponse? uploadResponse,
  }) = _DocSummarizerStateStore;
}
