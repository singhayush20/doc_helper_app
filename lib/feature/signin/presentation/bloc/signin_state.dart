part of 'signin_bloc.dart';

@freezed
sealed class SignInState extends BaseState with _$SignInState {
  const SignInState._();

  const factory SignInState.initial({required SignInStateStore store}) =
      _SignInStateInitial;

  const factory SignInState.invalidateLoader({
    required SignInStateStore store,
  }) = InvalidateLoader;

  const factory SignInState.onException({
    required SignInStateStore store,
    required Exception exception,
  }) = OnException;

  @override
  BaseState getExceptionState(Exception exception) => SignInState.onException(
    store: store.copyWith(loading: false),
    exception: exception,
  );

  @override
  BaseState getLoaderState({required bool loading}) =>
      SignInState.invalidateLoader(store: store.copyWith(loading: loading));
}

@liteFreezed
sealed class SignInStateStore with _$SignInStateStore {
  const factory SignInStateStore({@Default(false) bool loading}) =
      _SignInStateStore;
}
