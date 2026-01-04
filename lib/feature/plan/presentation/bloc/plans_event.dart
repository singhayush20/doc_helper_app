part of 'plans_bloc.dart';

@freezed
class PlansEvent extends BaseEvent with _$PlansEvent {
  const PlansEvent._() : super();

  const factory PlansEvent.started() = _Started;
}
