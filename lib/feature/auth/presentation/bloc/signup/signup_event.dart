part of 'signup_bloc.dart';

@freezed
sealed class SignUpEvent extends BaseEvent with _$SignUpEvent {
  const SignUpEvent._() : super();

  const factory SignUpEvent.started() = _Started;

  const factory SignUpEvent.onEmailChanged({required String emailString}) =
      _OnEmailChanged;

  const factory SignUpEvent.onPasswordChanged({
    required String passwordString,
  }) = _OnPasswordChanged;

  const factory SignUpEvent.onConfirmPasswordChanged({
    required String confirmPasswordString,
  }) = _OnConfirmPasswordChanged;

  const factory SignUpEvent.onFirstNameChanged({
    required String firstNameString,
  }) = _OnFirstNameChanged;

  const factory SignUpEvent.onLastNameChanged({
    required String lastNameString,
  }) = _OnLastNameChanged;

  const factory SignUpEvent.onCreateAccountClicked() = _OnCreateAccountClicked;

  const factory SignUpEvent.onPasswordVisibilityChanged() =
      _OnPasswordVisibilityChanged;

  const factory SignUpEvent.onSignInPressed() = _OnSignInPressed;

  const factory SignUpEvent.onEmailOTPChanged({
    required String? emailOTPString,
  }) = _OnEmailOTPChanged;

  const factory SignUpEvent.onResendOTPPressed() = _OnResendOTPPressed;

  const factory SignUpEvent.onTimerStarted() = _OnTimerStarted;

  const factory SignUpEvent.onTimerTicked({required int timerValue}) =
      _OnTimerTicked;

  const factory SignUpEvent.onVerifyOTPPressed() = _OnVerifyOTPPressed;
}
