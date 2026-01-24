part of 'payment_bloc.dart';

@freezed
sealed class PaymentState extends BaseState with _$PaymentState {
  const PaymentState._();

  const factory PaymentState.initial({required PaymentStateStore store}) =
      _Initial;

  const factory PaymentState.onBillingPriceFetch({
    required PaymentStateStore store,
  }) = _OnBillingPriceFetch;

  const factory PaymentState.onCheckoutCreate({
    required PaymentStateStore store,
    required CheckoutSessionInfo? session,
  }) = OnCheckoutCreate;

  const factory PaymentState.onPaymentSuccess({
    required PaymentStateStore store,
  }) = OnPaymentSuccess;

  const factory PaymentState.onPaymentFailure({
    required PaymentStateStore store,
  }) = OnPaymentFailure;

  const factory PaymentState.onExternalWalletEvent({
    required PaymentStateStore store,
  }) = OnExternalWalletEvent;

  const factory PaymentState.onTransactionCancel({
    required PaymentStateStore store,
}) = OnTranasctionCancel;

  const factory PaymentState.invalidateLoader({
    required PaymentStateStore store,
  }) = InvalidateLoader;

  const factory PaymentState.onException({
    required PaymentStateStore store,
    required Exception exception,
  }) = OnException;

  @override
  BaseState getExceptionState(Exception exception) => PaymentState.onException(
    store: store.copyWith(loading: false),
    exception: exception,
  );

  @override
  BaseState getLoaderState({required bool loading}) =>
      PaymentState.invalidateLoader(store: store.copyWith(loading: loading));
}

@liteFreezed
sealed class PaymentStateStore with _$PaymentStateStore {
  const factory PaymentStateStore({
    BillingPricesResponse? pricesResponse,
    BillingProductInfo? billingProductInfo,
    String? selectedPriceCode,
    CheckoutSessionInfo? checkoutSession,
    PaymentGatewaySuccess? paymentSuccess,
    PaymentGatewayFailure? paymentFailure,
    PaymentGatewayExternalWallet? paymentExternalWallet,
    @Default(false) bool refreshOnBackRequired,
    @Default(false) bool loading,
  }) = _PaymentStateStore;
}
