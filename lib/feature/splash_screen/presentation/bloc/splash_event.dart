part of 'splash_bloc.dart';

@freezed
sealed class SplashEvent extends BaseEvent with _$SplashEvent {
  const SplashEvent._() : super();

  const factory SplashEvent.started(Map<String, dynamic>? args) = _Started;
}
