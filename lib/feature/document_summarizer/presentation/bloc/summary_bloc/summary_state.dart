part of 'summary_bloc.dart';

@freezed
sealed class SummaryState extends BaseState with _$SummaryState {
  const SummaryState._();

  const factory SummaryState.initial({required SummaryStateStore store}) =
      Initial;

  const factory SummaryState.onSummaryDataFetch({
    required SummaryStateStore store,
  }) = OnSummaryDataFetch;

  const factory SummaryState.invalidateLoader({
    required SummaryStateStore store,
  }) = InvalidateLoader;

  const factory SummaryState.onException({
    required SummaryStateStore store,
    required Exception exception,
  }) = OnException;

  const factory SummaryState.onValidationError({
    required SummaryStateStore store,
  }) = OnValidationError;

  @override
  BaseState getExceptionState(Exception exception) => SummaryState.onException(
    store: store.copyWith(loading: false),
    exception: exception,
  );

  @override
  BaseState getLoaderState({required bool loading}) =>
      SummaryState.invalidateLoader(store: store.copyWith(loading: loading));
}

@liteFreezed
sealed class SummaryStateStore with _$SummaryStateStore {
  const factory SummaryStateStore({
    final SummaryListResponse? docSummaries,
    @Default(false) bool loading}) =
      _SummaryStateStore;
}
