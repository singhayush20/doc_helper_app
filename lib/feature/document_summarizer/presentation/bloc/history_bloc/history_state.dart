part of 'history_bloc.dart';

@freezed
sealed class HistoryState extends BaseState with _$HistoryState {
  const HistoryState._();

  const factory HistoryState.initial({required HistoryStateStore store}) =
      Initial;

  const factory HistoryState.invalidateLoader({
    required HistoryStateStore store,
  }) = InvalidateLoader;

  const factory HistoryState.onException({
    required HistoryStateStore store,
    required Exception exception,
  }) = OnException;

  const factory HistoryState.onHistoryDataFetch({
    required HistoryStateStore store,
  }) = OnHistoryDataFetch;

  const factory HistoryState.onSearch({required HistoryStateStore store}) =
      OnSearch;

  const factory HistoryState.onDocumentPress({
    required HistoryStateStore store,
    required int? documentId,
  }) = OnDocumentPress;

  @override
  BaseState getExceptionState(Exception exception) => HistoryState.onException(
    store: store.copyWith(loading: false),
    exception: exception,
  );

  @override
  BaseState getLoaderState({required bool loading}) =>
      HistoryState.invalidateLoader(store: store.copyWith(loading: loading));
}

@liteFreezed
sealed class HistoryStateStore with _$HistoryStateStore {
  const factory HistoryStateStore({
    @Default(false) bool loading,
    DocumentListResponse? documentsInfo,
    List<DocumentDetails?>? filteredDocuments,
    @Default('') String searchQuery,
  }) = _HistoryStateStore;
}
