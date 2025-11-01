part of 'password_reset_bloc.dart';

@freezed
sealed class PasswordResetState extends BaseState with _$PasswordResetState {
  const PasswordResetState._();

  const factory PasswordResetState.initial({
    required PasswordResetStateStore store,
  }) = _Initial;

  const factory PasswordResetState.onEmailChange({
    required PasswordResetStateStore store,
  }) = OnEmailChange;

  const factory PasswordResetState.onOtpSent({
    required PasswordResetStateStore store,
  }) = OnOtpSent;

  const factory PasswordResetState.onTimerUpdate({
    required PasswordResetStateStore store,
  }) = OnTimerUpdate;

  const factory PasswordResetState.onChangeEmailPress({
    required PasswordResetStateStore store,
  }) = OnChangeEmailPress;

  const factory PasswordResetState.onSendOTPPress({
    required PasswordResetStateStore store,
  }) = OnSendOTPPress;

  const factory PasswordResetState.onOTPChange({
    required PasswordResetStateStore store,
  }) = OnOTPChange;

  const factory PasswordResetState.onResetPasswordPress({
    required PasswordResetStateStore store,
  }) = OnResetPasswordPress;

  const factory PasswordResetState.onPasswordChange({
    required PasswordResetStateStore store,
  }) = OnPasswordChange;

  const factory PasswordResetState.onConfirmPasswordChange({
    required PasswordResetStateStore store,
  }) = OnConfirmPasswordChange;

  const factory PasswordResetState.onPasswordVisibilityChange({
    required PasswordResetStateStore store,
  }) = OnPasswordVisibilityChange;

  const factory PasswordResetState.onPasswordSaved({
    required PasswordResetStateStore store,
  }) = OnPasswordSaved;

  const factory PasswordResetState.invalidateLoader({
    required PasswordResetStateStore store,
  }) = InvalidateLoader;

  const factory PasswordResetState.onException({
    required PasswordResetStateStore store,
    required Exception exception,
  }) = OnException;

  @override
  BaseState getExceptionState(Exception exception) =>
      PasswordResetState.onException(
        store: store.copyWith(loading: false),
        exception: exception,
      );

  @override
  BaseState getLoaderState({required bool loading}) =>
      PasswordResetState.invalidateLoader(
        store: store.copyWith(loading: loading),
      );
}

@liteFreezed
sealed class PasswordResetStateStore with _$PasswordResetStateStore {
  const factory PasswordResetStateStore({
    EmailAddress? email,
    Password? password,
    Password? confirmPassword,
    Otp? otp,
    int? timerValue,
    String? parentRoute,
    @Default(false) bool otpSent,
    @Default(false) bool isPasswordVisible,
    @Default(false) bool loading,
  }) = _PasswordResetStateStore;
}
