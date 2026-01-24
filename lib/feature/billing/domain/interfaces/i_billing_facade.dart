import 'package:dartz/dartz.dart';
import 'package:doc_helper_app/core/exception_handling/server_exception.dart';
import 'package:doc_helper_app/feature/billing/domain/entities/billing_entity.dart';

abstract class IBillingFacade {
  Future<Either<ServerException, BillingProductsInfoList?>>
  getBillingProducts();

  Future<Either<ServerException, BillingPricesResponse?>>
  getActiveBillingPricesForProduct(int productId);

  Future<Either<ServerException, CheckoutSessionInfo?>> checkout(
    String priceCode,
  );

  Future<Either<ServerException, SubscriptionResponse?>>
  getCurrentSubscriptionDetails();

  Future<Either<ServerException, Unit>> cancelSubscription();

  Future<Either<ServerException, Unit>> cancelCheckout({
    required int? errorCode,
    required String? message,
  });
}
