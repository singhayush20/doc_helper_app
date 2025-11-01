part of 'password_reset_bloc.dart';

@freezed
sealed class PasswordResetEvent extends BaseEvent with _$PasswordResetEvent {
  const PasswordResetEvent._() : super();

  const factory PasswordResetEvent.started({required String? parentRoute}) =
      _Started;

  const factory PasswordResetEvent.onEmailChanged({
    required String emailString,
  }) = _OnEmailChanged;

  const factory PasswordResetEvent.onChangeEmailPressed() =
      _OnChangeEmailPressed;

  const factory PasswordResetEvent.onTimerStarted() = _OnTimerStarted;

  const factory PasswordResetEvent.onTimerTicked({required int timerValue}) =
      _OnTimerTicked;

  const factory PasswordResetEvent.onSendOTPPressed() = _OnSendOTPPressed;

  const factory PasswordResetEvent.onOTPChanged({required String? otpString}) =
      _OnOTPChanged;

  const factory PasswordResetEvent.onResendOTPPressed() = _OnResendOTPPressed;

  const factory PasswordResetEvent.onPasswordChanged({
    required String passwordString,
  }) = _OnPasswordChanged;

  const factory PasswordResetEvent.onConfirmPasswordChanged({
    required String passwordString,
  }) = _OnConfirmPasswordChanged;

  const factory PasswordResetEvent.onPasswordVisibilityChanged() =
      _OnPasswordVisibilityChanged;

  const factory PasswordResetEvent.onSavePasswordPressed() =
      _OnSavePasswordPressed;
}
