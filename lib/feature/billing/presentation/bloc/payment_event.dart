part of 'payment_bloc.dart';

@freezed
sealed class PaymentEvent extends BaseEvent with _$PaymentEvent {
  const PaymentEvent._() : super();

  const factory PaymentEvent.started({
    required BillingProductInfo? billingProductInfo,
  }) = _Started;

  const factory PaymentEvent.selectPrice({
    required String? priceCode,
  }) = _SelectPrice;

  const factory PaymentEvent.checkoutStarted({
    required String priceCode,
  }) = _CheckoutStarted;
}
