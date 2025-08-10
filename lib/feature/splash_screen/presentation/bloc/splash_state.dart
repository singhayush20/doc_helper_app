part of 'splash_bloc.dart';

@freezed
sealed class SplashState extends BaseState with _$SplashState {
  const SplashState._();

  const factory SplashState.initial({required SplashStateStore store}) =
      Initial;

  const factory SplashState.onCurrentUserFetch({
    required SplashStateStore store,
    required AppUser? user,
  }) = OnCurrentUserFetch;

  const factory SplashState.invalidateLoader({
    required SplashStateStore store,
  }) = InvalidateLoader;

  const factory SplashState.onException({
    required SplashStateStore store,
    required Exception exception,
  }) = OnException;

  @override
  BaseState getExceptionState(Exception exception) => SplashState.onException(
    store: store.copyWith(loading: false),
    exception: exception,
  );

  @override
  BaseState getLoaderState({required bool loading}) =>
      SplashState.invalidateLoader(store: store.copyWith(loading: loading));
}

@liteFreezed
sealed class SplashStateStore with _$SplashStateStore {
  const factory SplashStateStore({@Default(false) bool loading}) =
      _SplashStateStore;
}
