part of 'splash_bloc.dart';

@freezed
sealed class SplashState extends BaseState with _$SplashState {
  const SplashState._();

  const factory SplashState.initial({required SignUpStateStore store}) =
      Initial;

  const factory SplashState.onCurrentUserFetch({
    required SignUpStateStore store,
  }) = OnCurrentUserFetch;

  const factory SplashState.invalidateLoader({
    required SignUpStateStore store,
  }) = InvalidateLoader;

  const factory SplashState.onException({
    required SignUpStateStore store,
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
sealed class SignUpStateStore with _$SignUpStateStore {
  const factory SignUpStateStore({@Default(false) bool loading}) =
      _SignUpStateStore;
}
