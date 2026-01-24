import 'dart:async';

import 'package:doc_helper_app/core/common/base_bloc/base_bloc.dart';
import 'package:doc_helper_app/core/common/base_bloc/base_event.dart';
import 'package:doc_helper_app/core/common/base_bloc/base_state.dart';
import 'package:doc_helper_app/core/common/constants/app_constants.dart';
import 'package:doc_helper_app/core/common/utils/app_utils.dart';
import 'package:doc_helper_app/feature/billing/domain/entities/billing_entity.dart';
import 'package:doc_helper_app/feature/billing/domain/interfaces/i_billing_facade.dart';
import 'package:doc_helper_app/feature/payment_gateway/domain/entities/payment_event.dart';
import 'package:doc_helper_app/feature/payment_gateway/domain/interface/i_payment_gateway_facade.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'payment_event.dart';

part 'payment_state.dart';

part 'payment_bloc.freezed.dart';

@injectable
class PaymentBloc extends BaseBloc<PaymentEvent, PaymentState> {
  PaymentBloc(this._billingFacade, this._paymentGatewayFacade)
    : super(const PaymentState.initial(store: PaymentStateStore()));

  final IBillingFacade _billingFacade;
  final IPaymentGatewayFacade _paymentGatewayFacade;
  StreamSubscription<PaymentGatewayEvent>? _paymentGatewayStreamSubscription;

  @override
  void handleEvents() {
    on<_Started>(_onStarted);
    on<_SelectPrice>(_onSelectPrice);
    on<_CheckoutStarted>(_onCheckoutStarted);
    on<_InitiateTransaction>(_initiateTransaction);
    on<_OnPaymentSuccess>(_paymentSuccess);
    on<_OnPaymentFailure>(_paymentFailure);
    on<_OnExternalWalletEvent>(_externalWalletEvent);
    on<_OnPaymentFailed>(_onPaymentFailed);
  }

  Future<void> _onStarted(_Started event, Emitter<PaymentState> emit) async {
    invalidateLoader(emit, loading: true);
    final billingPricesOrFailure = await _billingFacade
        .getActiveBillingPricesForProduct(event.billingProductInfo?.id ?? 0);

    billingPricesOrFailure.fold(
      (exception) => handleException(emit, exception),
      (billingPricesResponse) {
        final firstActivePrice = billingPricesResponse?.prices?.firstWhere(
          (p) => (p?.active ?? true),
          orElse: () => billingPricesResponse.prices?.first,
        );
        final firstActivePriceCode = firstActivePrice?.priceCode;

        emit(
          PaymentState.onBillingPriceFetch(
            store: state.store.copyWith(
              billingProductInfo: event.billingProductInfo,
              pricesResponse: billingPricesResponse,
              selectedPriceCode: firstActivePriceCode,
              loading: false,
            ),
          ),
        );
      },
    );
  }

  void _onSelectPrice(_SelectPrice event, Emitter<PaymentState> emit) {
    emit(
      PaymentState.onBillingPriceFetch(
        store: state.store.copyWith(selectedPriceCode: event.priceCode),
      ),
    );
  }

  Future<void> _onCheckoutStarted(
    _CheckoutStarted event,
    Emitter<PaymentState> emit,
  ) async {
    invalidateLoader(emit, loading: true);
    final checkoutOrFailure = await _billingFacade.checkout(event.priceCode);

    checkoutOrFailure.fold(
      (exception) => handleException(emit, exception),
      (checkoutSessionInfo) => emit(
        PaymentState.onCheckoutCreate(
          store: state.store.copyWith(
            checkoutSession: checkoutSessionInfo,
            loading: false,
          ),
          session: checkoutSessionInfo,
        ),
      ),
    );
  }

  Future<void> _initiateTransaction(_, Emitter<PaymentState> emit) async {
    await _paymentGatewayFacade.startCheckout(state.store.checkoutSession);

    _paymentGatewayStreamSubscription = _paymentGatewayFacade
        .paymentGatewayStream
        ?.listen(
          (event) => switch (event) {
            PaymentGatewaySuccess() => _onPaymentSuccess(event),
            PaymentGatewayFailure() => _onPaymentFailure(event),
            PaymentGatewayExternalWallet() => _onExternalWalletEvent(event),
          },
          onError: (error) {
            // TODO: Handle error gracefully
          },
        );
  }

  void _paymentSuccess(_OnPaymentSuccess event, Emitter<PaymentState> emit) {
    emit(
      PaymentState.onPaymentSuccess(
        store: state.store.copyWith(
          paymentSuccess: event.event,
          refreshOnBackRequired: true,
        ),
      ),
    );
  }

  void _paymentFailure(_OnPaymentFailure event, Emitter<PaymentState> emit) {
    emit(
      PaymentState.onPaymentFailure(
        store: state.store.copyWith(
          paymentFailure: event.event,
          refreshOnBackRequired: true,
        ),
      ),
    );
  }

  void _externalWalletEvent(
    _OnExternalWalletEvent event,
    Emitter<PaymentState> emit,
  ) {
    emit(
      PaymentState.onExternalWalletEvent(
        store: state.store.copyWith(
          paymentExternalWallet: event.event,
          refreshOnBackRequired: true,
        ),
      ),
    );
  }

  Future<void> _onPaymentFailed(_, Emitter<PaymentState> emit) async {
    invalidateLoader(emit, loading: true);
    final cancelCheckoutResponseOrFailure = await _billingFacade.cancelCheckout(
      errorCode: state.store.paymentFailure?.code,
      message: state.store.paymentFailure?.message,
    );
    cancelCheckoutResponseOrFailure.fold(
      (exception) => handleException(emit, exception),
      (_) => emit(
        PaymentState.onTransactionCancel(
          store: state.store.copyWith(loading: false),
        ),
      ),
    );
  }

  @override
  void started({Map<String, dynamic>? args}) {
    final product = args?[AppConstants.product] as BillingProductInfo;
    add(PaymentEvent.started(billingProductInfo: product));
  }

  @override
  Future<void> close() async {
    _paymentGatewayStreamSubscription?.cancel();
    _paymentGatewayFacade.dispose();
    super.close();
  }

  void onSelectPrice({required String? priceCode}) {
    add(PaymentEvent.selectPrice(priceCode: priceCode));
  }

  void onCheckoutStarted({required String? priceCode}) {
    add(PaymentEvent.checkoutStarted(priceCode: priceCode ?? ''));
  }

  void initiateTransaction() {
    add(const PaymentEvent.initiateTransaction());
  }

  void _onPaymentSuccess(PaymentGatewaySuccess event) {
    add(PaymentEvent.onPaymentSuccess(event: event));
  }

  void _onPaymentFailure(PaymentGatewayFailure event) {
    add(PaymentEvent.onPaymentFailure(event: event));
  }

  void _onExternalWalletEvent(PaymentGatewayExternalWallet event) {
    add(PaymentEvent.onExternalWalletEvent(event: event));
  }

  void onPaymentFailed() {
    add(const PaymentEvent.onPaymentFailed());
  }
}
