part of 'doc_summarizer_bloc.dart';

@freezed
sealed class DocSummarizerState extends BaseState with _$DocSummarizerState {
  const DocSummarizerState._();

  const factory DocSummarizerState.initial({
    required DocSummarizerStateStore store,
  }) = Initial;

  const factory DocSummarizerState.onDocumentDataFetch({
    required DocSummarizerStateStore store,
  }) = OnDocumentDataFetch;

  const factory DocSummarizerState.onUploadProgress({
    required DocSummarizerStateStore store,
  }) = OnUploadProgress;

  const factory DocSummarizerState.onUploadSuccess({
    required DocSummarizerStateStore store,
  }) = OnUploadSuccess;

  const factory DocSummarizerState.onDocumentPress({
    required DocSummarizerStateStore store,
    required int? documentId,
  }) = OnDocumentPress;

  const factory DocSummarizerState.onValidationError({
    required DocSummarizerStateStore store,
  }) = OnValidationError;

  const factory DocSummarizerState.onViewAllPress({
    required DocSummarizerStateStore store,
  }) = OnViewAllPress;

  const factory DocSummarizerState.invalidateLoader({
    required DocSummarizerStateStore store,
  }) = InvalidateLoader;

  const factory DocSummarizerState.onException({
    required DocSummarizerStateStore store,
    required Exception exception,
  }) = OnException;

  const factory DocSummarizerState.onPreferenceChanged({
    required DocSummarizerStateStore store,
  }) = OnPreferenceChanged;

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
    DocumentListResponse? documentsInfo,
    @Default(SummaryTone.professional) SummaryTone selectedTone,
    @Default(SummaryLength.medium) SummaryLength selectedLength,
  }) = _DocSummarizerStateStore;
}
