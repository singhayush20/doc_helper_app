part of 'profile_bloc.dart';

@freezed
sealed class ProfileState extends BaseState with _$ProfileState {
  const ProfileState._();

  const factory ProfileState.initial({required ProfileStateStore store}) =
      _Initial;

  const factory ProfileState.onUserInfoFetch({
    required ProfileStateStore store,
  }) = _OnUserInfoFetch;

  const factory ProfileState.onLogout({required ProfileStateStore store}) =
      OnLogout;

  const factory ProfileState.invalidateLoader({
    required ProfileStateStore store,
  }) = InvalidateLoader;

  const factory ProfileState.onException({
    required ProfileStateStore store,
    required Exception exception,
  }) = OnException;

  @override
  BaseState getExceptionState(Exception exception) => ProfileState.onException(
    store: store.copyWith(loading: false),
    exception: exception,
  );

  @override
  BaseState getLoaderState({required bool loading}) =>
      ProfileState.invalidateLoader(store: store.copyWith(loading: loading));
}

@liteFreezed
sealed class ProfileStateStore with _$ProfileStateStore {
  const factory ProfileStateStore({
    UserAccountInfo? userInfo,
    @Default(false) bool loading,
  }) = _ProfileStateStore;
}
