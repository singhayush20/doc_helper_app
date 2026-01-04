part of 'payment_bloc.dart';

@freezed
sealed class PaymentEvent extends BaseEvent with _$PaymentEvent {
  const PaymentEvent._() : super();

  const factory PaymentEvent.started({
    required BillingProductInfo? billingProductInfo,
  }) = _Started;

  const factory PaymentEvent.selectPrice({required String? priceCode}) =
      _SelectPrice;

  const factory PaymentEvent.checkoutStarted({required String priceCode}) =
      _CheckoutStarted;

  const factory PaymentEvent.initiateTransaction() = _InitiateTransaction;

  const factory PaymentEvent.onPaymentSuccess({
    required PaymentGatewaySuccess event,
  }) = _OnPaymentSuccess;

  const factory PaymentEvent.onPaymentFailure({
    required PaymentGatewayFailure event,
  }) = _OnPaymentFailure;

  const factory PaymentEvent.onExternalWalletEvent({
    required PaymentGatewayExternalWallet event,
  }) = _OnExternalWalletEvent;
}
