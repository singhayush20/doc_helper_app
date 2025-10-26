part of 'home_bloc.dart';

@freezed
sealed class HomeEvent extends BaseEvent with _$HomeEvent {
  const HomeEvent._() : super();

  const factory HomeEvent.started() = _Started;
}
