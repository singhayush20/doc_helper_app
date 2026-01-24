import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:doc_helper_app/core/common/base_bloc/base_bloc.dart';
import 'package:doc_helper_app/core/common/base_bloc/base_event.dart';
import 'package:doc_helper_app/core/common/base_bloc/base_state.dart';
import 'package:doc_helper_app/core/common/utils/app_utils.dart';
import 'package:doc_helper_app/core/exception_handling/server_exception.dart';
import 'package:doc_helper_app/feature/billing/domain/entities/billing_entity.dart';
import 'package:doc_helper_app/feature/billing/domain/interfaces/i_billing_facade.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'plans_event.dart';

part 'plans_state.dart';

part 'plans_bloc.freezed.dart';

@injectable
class PlansBloc extends BaseBloc<PlansEvent, PlansState> {
  PlansBloc(this._billingFacade)
    : super(const PlansState.initial(store: PlansStateStore()));

  final IBillingFacade _billingFacade;

  @override
  void handleEvents() {
    on<_Started>(_onStarted);
    on<_OnCancelPlan>(_onCancelPlan);
    on<_OnRefreshSubscriptionData>(_onRefreshSubscriptionData);
    on<_OnBuyTapped>(_onBuyTapped);
  }

  Future<void> _onStarted(_Started event, Emitter<PlansState> emit) async {
    Either<ServerException, BillingProductsInfoList?>?
    billingProductsListOrFailure;
    Either<ServerException, SubscriptionResponse?>?
    subscriptionDetailsOrFailure;
    await Future.wait([
      (() async => billingProductsListOrFailure = await _billingFacade
          .getBillingProducts())(),
      (() async => subscriptionDetailsOrFailure = await _billingFacade
          .getCurrentSubscriptionDetails())(),
    ]);

    subscriptionDetailsOrFailure?.fold(
      (exception) => handleException(emit, exception),
      (subscriptionDetails) {
        billingProductsListOrFailure?.fold(
          (exception) => handleException(emit, exception),
          (billingProductsList) => emit(
            PlansState.onPlansInfoFetch(
              store: state.store.copyWith(
                subscriptionDetails: subscriptionDetails,
                billingProductsInfoList: billingProductsListOrFailure
                    ?.getOrElse(() => null),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _onCancelPlan(
    _OnCancelPlan event,
    Emitter<PlansState> emit,
  ) async {
    invalidateLoader(emit, loading: true);
    final cancelResponseOrFailure = await _billingFacade.cancelSubscription();
    cancelResponseOrFailure.fold(
      (exception) => handleException(emit, exception),
      (_) => emit(
        PlansState.onPlanCancel(store: state.store.copyWith(loading: false)),
      ),
    );
  }

  Future<void> _onRefreshSubscriptionData(_, Emitter<PlansState> emit) async {
    emit(
      PlansState.onDataRefreshed(
        store: state.store.copyWith(
          subscriptionDetails: null,
          refreshOnBackRequired: true,
          billingProductsInfoList: null,
        ),
      ),
    );
  }

  void _onBuyTapped(_OnBuyTapped event, Emitter<PlansState> emit) {
    invalidateLoader(emit,loading: false);
    emit(
      PlansState.onBuyTap(store: state.store, selectedProduct: event.product),
    );
  }

  @override
  void started({Map<String, dynamic>? args}) {
    add(const PlansEvent.started());
  }

  void onCancelPlan() {
    add(const PlansEvent.onCancelPlan());
  }

  void onBuyTapped({required BillingProductInfo product}) {
    add(PlansEvent.onBuyTapped(product: product));
  }

  void onRefreshSubscriptionData() {
    add(const PlansEvent.onRefreshSubscriptionData());
  }
}
