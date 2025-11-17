part of 'user_doc_bloc.dart';

@freezed
sealed class UserDocState extends BaseState with _$UserDocState {
  const UserDocState._();

  const factory UserDocState.initial({required UserDocStateStore store}) =
      _Initial;

  const factory UserDocState.onNextPageFetchStart({
    required UserDocStateStore store,
  }) = _OnNextPageFetchStart;

  const factory UserDocState.onNextPageFetchError({
    required UserDocStateStore store,
    required Exception exception,
  }) = OnNextPageFetchError;

  const factory UserDocState.onNextPageFetch({
    required UserDocStateStore store,
  }) = OnNextPageFetch;

  const factory UserDocState.onSearchQueryChange({
    required UserDocStateStore store,
  }) = OnSearchQueryChange;

  const factory UserDocState.onSearchCleared({
    required UserDocStateStore store,
  }) = OnSearchCleared;

  const factory UserDocState.invalidateLoader({
    required UserDocStateStore store,
  }) = InvalidateLoader;

  const factory UserDocState.onException({
    required UserDocStateStore store,
    required Exception exception,
  }) = OnException;

  @override
  BaseState getExceptionState(Exception exception) => UserDocState.onException(
    store: store.copyWith(loading: false),
    exception: exception,
  );

  @override
  BaseState getLoaderState({required bool loading}) =>
      UserDocState.invalidateLoader(store: store.copyWith(loading: loading));
}

@liteFreezed
sealed class UserDocStateStore with _$UserDocStateStore {
  const factory UserDocStateStore({
    required PagingState<int, UserDoc> userDocsPagingState,
    UserDocList? userDocList,
    @Default(false) bool isSearchMode,
    @Default('') String searchQuery,
    @Default('') String lastSearchedQuery,
    required PagingState<int, UserDoc> searchPagingState,
    UserDocList? searchUserDocList,
    @Default(false) bool loading,
  }) = _UserDocStateStore;
}
