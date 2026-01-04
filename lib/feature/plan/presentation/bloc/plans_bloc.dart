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
  }

  Future<void> _onStarted(_Started event, Emitter<PlansState> emit) async {
    Either<ServerException, BillingProductsInfoList?>?
    billingProductsListOrFailure;
    Either<ServerException, SubscriptionResponse?>?
    subscriptionDetailsOrFailure;
    invalidateLoader(emit, loading: true);
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
                loading: false,
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

  @override
  void started({Map<String, dynamic>? args}) {
    add(const PlansEvent.started());
  }
}
