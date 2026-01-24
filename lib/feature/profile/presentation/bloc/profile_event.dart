part of 'profile_bloc.dart';

@freezed
sealed class ProfileEvent extends BaseEvent with _$ProfileEvent {
  const ProfileEvent._() : super();

  const factory ProfileEvent.started() = _Started;

  const factory ProfileEvent.onLogoutPressed() = _OnLogoutPressed;

  const factory ProfileEvent.onResetPasswordPressed() = _OnResetPasswordPressed;

  const factory ProfileEvent.onManageSubscriptionTapped() =
      _OnManageSubscriptionTapped;
}
