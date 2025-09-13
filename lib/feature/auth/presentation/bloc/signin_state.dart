part of 'signin_bloc.dart';

@freezed
sealed class SignInState extends BaseState with _$SignInState {
  const SignInState._();

  const factory SignInState.initial({required SignInStateStore store}) =
      _SignInStateInitial;

  const factory SignInState.onEmailChange({required SignInStateStore store}) =
      OnEmailChange;

  const factory SignInState.onPasswordChange({
    required SignInStateStore store,
  }) = OnPasswordChange;

  const factory SignInState.onPasswordVisibilityChange({
    required SignInStateStore store,
  }) = OnPasswordVisibilityChange;

  const factory SignInState.onLogin({required SignInStateStore store}) =
      OnLogin;

  const factory SignInState.onSignUpPressed({required SignInStateStore store}) =
      OnSignUpPressed;

  const factory SignInState.onForgotPasswordPressed({
    required SignInStateStore store,
  }) = OnForgotPasswordPressed;

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
  const factory SignInStateStore({
    EmailAddress? email,
    Password? password,
    @Default(false) bool isPasswordVisible,
    @Default(false) bool loading,
  }) = _SignInStateStore;
}
