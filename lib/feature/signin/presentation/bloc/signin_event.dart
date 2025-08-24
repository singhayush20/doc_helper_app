part of 'signin_bloc.dart';

@freezed
sealed class SignInEvent extends BaseEvent with _$SignInEvent {
  const SignInEvent._() : super();

  const factory SignInEvent.started() = _Started;

  const factory SignInEvent.onEmailChanged({required String emailString}) =
      _OnEmailChanged;

  const factory SignInEvent.onPasswordChanged({
    required String passwordString,
  }) = _OnPasswordChanged;

  const factory SignInEvent.onSignInClicked() = _OnSignInClicked;

  const factory SignInEvent.onPasswordVisibilityChanged() =
      _OnPasswordVisibilityChanged;
}
