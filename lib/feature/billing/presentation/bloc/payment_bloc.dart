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
  }

  Future<void> _onStarted(_Started event, Emitter<PaymentState> emit) async {
    invalidateLoader(emit, loading: true);
    final billingPricesOrFailure = await _billingFacade
        .getActiveBillingPricesForProduct(event.billingProductInfo?.id ?? 0);

    billingPricesOrFailure.fold(
      (exception) => handleException(emit, exception),
      (billingPricesResponse) => emit(
        PaymentState.onBillingPriceFetch(
          store: state.store.copyWith(
            billingProductInfo: event.billingProductInfo,
            pricesResponse: billingPricesResponse,
            loading: false,
          ),
        ),
      ),
    );
  }

  @override
  void started({Map<String, dynamic>? args}) {
    final product = args?[AppConstants.product] as BillingProductInfo;
    add(PaymentEvent.started(billingProductInfo: product));
  }
}
