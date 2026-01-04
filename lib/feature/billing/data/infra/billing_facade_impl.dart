import 'package:dartz/dartz.dart';
import 'package:doc_helper_app/core/exception_handling/server_exception.dart';
import 'package:doc_helper_app/core/network/api_call_handler.dart';
import 'package:doc_helper_app/core/network/retrofit_api_client.dart';
import 'package:doc_helper_app/env/env_config.dart';
import 'package:doc_helper_app/feature/billing/data/models/billing_dto.dart';
import 'package:doc_helper_app/feature/billing/data/models/dto_to_model_mapper.dart';
import 'package:doc_helper_app/feature/billing/domain/entities/billing_entity.dart';
import 'package:doc_helper_app/feature/billing/domain/interfaces/i_billing_facade.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: IBillingFacade, env: injectionEnv)
class BillingFacadeImpl implements IBillingFacade {
  BillingFacadeImpl(this._retrofitApiClient, this._apiCallHandler);

  final RetrofitApiClient _retrofitApiClient;
  final ApiCallHandler _apiCallHandler;

  @override
  Future<Either<ServerException, BillingProductsInfoList?>>
  getBillingProducts() async {
    final responseOrError = await _apiCallHandler.handleApi(
      _retrofitApiClient.getActiveBillingProducts,
    );

    return responseOrError.fold(
      (exception) => left(exception),
      (response) =>
          right(BillingProductsInfoListDto.fromJson(response.data).toDomain()),
    );
  }

  @override
  Future<Either<ServerException, BillingPricesResponse?>>
  getActiveBillingPricesForProduct(int productId) async {
    final responseOrError = await _apiCallHandler.handleApi(
      () => _retrofitApiClient.getActiveBillingPricesForProduct(productId),
    );

    return responseOrError.fold(
      (exception) => left(exception),
      (response) =>
          right(BillingPricesResponseDto.fromJson(response.data).toDomain()),
    );
  }

  @override
  Future<Either<ServerException, CheckoutSessionInfo?>> subscribe(
    String priceCode,
  ) async {
    final responseOrError = await _apiCallHandler.handleApi(
      () => _retrofitApiClient.subscribe(priceCode),
    );

    return responseOrError.fold(
      (exception) => left(exception),
      (response) =>
          right(CheckoutSessionInfoDto.fromJson(response.data).toDomain()),
    );
  }

  @override
  Future<Either<ServerException, SubscriptionResponse?>>
  getCurrentSubscriptionDetails() async {
    final responseOrError = await _apiCallHandler.handleApi(
      _retrofitApiClient.getCurrentSubscriptionDetails,
    );

    return responseOrError.fold(
      (exception) => left(exception),
      (response) =>
          right(SubscriptionResponseDto.fromJson(response.data).toDomain()),
    );
  }

  @override
  Future<Either<ServerException, Unit>> cancelSubscription() async {
    final responseOrError = await _apiCallHandler.handleApi(
      _retrofitApiClient.cancelSubscription,
    );

    return responseOrError.fold(
      (exception) => left(exception),
      (response) => right(unit),
    );
  }
}
