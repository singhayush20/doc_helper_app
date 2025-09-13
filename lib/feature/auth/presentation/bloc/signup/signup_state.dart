part of 'signup_bloc.dart';

@freezed
sealed class SignUpState extends BaseState with _$SignUpState {
  const SignUpState._();

  const factory SignUpState.initial({required SignUpStateStore store}) =
      _SignInStateInitial;

  const factory SignUpState.onEmailChange({required SignUpStateStore store}) =
      OnEmailChange;

  const factory SignUpState.onPasswordChange({
    required SignUpStateStore store,
  }) = OnPasswordChange;

  const factory SignUpState.onConfirmPasswordChange({
    required SignUpStateStore store,
  }) = OnConfirmPasswordChanged;

  const factory SignUpState.onFirstNameChange({
    required SignUpStateStore store,
  }) = OnFirstNameChange;

  const factory SignUpState.onLastNameChange({
    required SignUpStateStore store,
  }) = OnLastNameChange;

  const factory SignUpState.onAccountCreate({required SignUpStateStore store}) =
      OnAccountCreate;

  const factory SignUpState.onPasswordVisibilityChange({
    required SignUpStateStore store,
  }) = OnPasswordVisibilityChange;

  const factory SignUpState.invalidateLoader({
    required SignUpStateStore store,
  }) = InvalidateLoader;

  const factory SignUpState.onException({
    required SignUpStateStore store,
    required Exception exception,
  }) = OnException;

  @override
  BaseState getExceptionState(Exception exception) => SignUpState.onException(
    store: store.copyWith(loading: false),
    exception: exception,
  );

  @override
  BaseState getLoaderState({required bool loading}) =>
      SignUpState.invalidateLoader(store: store.copyWith(loading: loading));
}

@liteFreezed
sealed class SignUpStateStore with _$SignUpStateStore {
  const factory SignUpStateStore({
    EmailAddress? email,
    Password? password,
    Password? confirmPassword,
    Name? firstName,
    Name? lastName,
    @Default(false) bool isPasswordVisible,
    @Default(false) bool loading,
  }) = _SignUpStateStore;
}
