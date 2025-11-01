part of 'email_verification_bloc.dart';

@freezed
sealed class EmailVerificationEvent extends BaseEvent
    with _$EmailVerificationEvent {
  const EmailVerificationEvent._() : super();

  const factory EmailVerificationEvent.started() = _Started;

  const factory EmailVerificationEvent.onEmailOTPChanged({
    required String? emailOTPString,
  }) = _OnEmailOTPChanged;

  const factory EmailVerificationEvent.onResendOTPPressed() =
      _OnResendOTPPressed;

  const factory EmailVerificationEvent.onTimerStarted() = _OnTimerStarted;

  const factory EmailVerificationEvent.onTimerTicked({
    required int timerValue,
  }) = _OnTimerTicked;

  const factory EmailVerificationEvent.onVerifyOTPPressed() =
      _OnVerifyOTPPressed;

  const factory EmailVerificationEvent.onLogoutPressed() = _OnLogoutPressed;
}
