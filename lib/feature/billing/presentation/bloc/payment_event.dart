part of 'payment_bloc.dart';

@freezed
sealed class PaymentEvent extends BaseEvent with _$PaymentEvent {
  const PaymentEvent._() : super();

  const factory PaymentEvent.started({
    required BillingProductInfo? billingProductInfo,
  }) = _Started;
}
