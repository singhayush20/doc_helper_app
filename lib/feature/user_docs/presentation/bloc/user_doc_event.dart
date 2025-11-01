part of 'user_doc_bloc.dart';

@freezed
sealed class UserDocEvent extends BaseEvent with _$UserDocEvent {
  const UserDocEvent._() : super();

  const factory UserDocEvent.started() = _Started;
}
