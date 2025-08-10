part of 'signin_bloc.dart';

@freezed
sealed class SignInEvent extends BaseEvent with _$SignInEvent {
  const SignInEvent._() : super();

  const factory SignInEvent.started() = _Started;
}
