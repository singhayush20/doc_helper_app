part of 'user_doc_bloc.dart';

@freezed
sealed class UserDocState extends BaseState with _$UserDocState {
  const UserDocState._();

  const factory UserDocState.initial({required UserDocStateStore store}) =
      _Initial;

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
  const factory UserDocStateStore({@Default(false) bool loading}) =
      _UserDocStateStore;
}
