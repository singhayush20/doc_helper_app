part of 'plans_bloc.dart';

@freezed
sealed class PlansEvent extends BaseEvent with _$PlansEvent {
  const PlansEvent._() : super();

  const factory PlansEvent.started() = _Started;

  const factory PlansEvent.onCancelPlan() = _OnCancelPlan;

  const factory PlansEvent.onBuyTapped({required BillingProductInfo product}) =
      _OnBuyTapped;

  const factory PlansEvent.onRefreshSubscriptionData() =
      _OnRefreshSubscriptionData;
}
