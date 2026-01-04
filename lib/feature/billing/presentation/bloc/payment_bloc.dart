import 'dart:async';

import 'package:doc_helper_app/core/common/base_bloc/base_bloc.dart';
import 'package:doc_helper_app/core/common/base_bloc/base_event.dart';
import 'package:doc_helper_app/core/common/base_bloc/base_state.dart';
import 'package:doc_helper_app/core/common/constants/app_constants.dart';
import 'package:doc_helper_app/core/common/utils/app_utils.dart';
import 'package:doc_helper_app/feature/billing/domain/entities/billing_entity.dart';
import 'package:doc_helper_app/feature/billing/domain/interfaces/i_billing_facade.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'payment_event.dart';

part 'payment_state.dart';

part 'payment_bloc.freezed.dart';

@injectable
class PaymentBloc extends BaseBloc<PaymentEvent, PaymentState> {
  PaymentBloc(this._billingFacade)
    : super(const PaymentState.initial(store: PaymentStateStore()));

  final IBillingFacade _billingFacade;

  @override
  void handleEvents() {
    on<_Started>(_onStarted);
    on<_SelectPrice>(_onSelectPrice);
    on<_CheckoutStarted>(_onCheckoutStarted);
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
    final checkoutOrFailure = await _billingFacade.subscribe(event.priceCode);

    checkoutOrFailure.fold(
      (exception) => handleException(emit, exception),
      (session) => emit(
        PaymentState.onCheckoutCreate(
          store: state.store.copyWith(checkoutSession: session, loading: false),
          session: session,
        ),
      ),
    );
  }

  @override
  void started({Map<String, dynamic>? args}) {
    final product = args?[AppConstants.product] as BillingProductInfo;
    add(PaymentEvent.started(billingProductInfo: product));
  }

  void onSelectPrice({required String? priceCode}) {
    add(PaymentEvent.selectPrice(priceCode: priceCode));
  }

  void onCheckoutStarted({required String? priceCode}) {
    add(PaymentEvent.checkoutStarted(priceCode: priceCode ?? ''));
  }
}
