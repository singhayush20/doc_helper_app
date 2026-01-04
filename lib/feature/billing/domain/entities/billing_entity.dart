import 'package:doc_helper_app/core/common/utils/app_utils.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'billing_entity.freezed.dart';

@liteFreezed
abstract class BillingProductsInfoList with _$BillingProductsInfoList {
  const factory BillingProductsInfoList({
    final List<BillingProductInfo?>? products,
  }) = _BillingProductsInfoList;
}

@liteFreezed
abstract class BillingProductInfo with _$BillingProductInfo {
  const factory BillingProductInfo({
    final int? id,
    final String? code,
    final String? displayName,
    final String? tier,
    final int? monthlyTokenLimit,
    final bool? active,
    final List<String?>? features,
  }) = _BillingProductInfo;
}

@liteFreezed
abstract class BillingPricesResponse with _$BillingPricesResponse {
  const factory BillingPricesResponse({
    final List<BillingPriceDetails?>? prices,
  }) = _BillingPricesResponse;
}

@liteFreezed
abstract class BillingPriceDetails with _$BillingPriceDetails {
  const factory BillingPriceDetails({
    final String? priceCode,
    final String? billingPeriod,
    final int? version,
    final int? amount,
    final String? currency,
    final String? providerPlanId,
    final bool? active,
  }) = _BillingPriceDetails;
}

@liteFreezed
abstract class CheckoutSessionResponse with _$CheckoutSessionResponse {
  const factory CheckoutSessionResponse({
    final String? providerSubscriptionId,
    final String? providerKeyId,
    final String? planCode,
    final String? priceCode,
  }) = _CheckoutSessionResponse;
}

@liteFreezed
abstract class SubscriptionResponse with _$SubscriptionResponse {
  const factory SubscriptionResponse({
    final String? planCode,
    final String? priceCode,
    final String? status,
    final bool? cancelAtPeriodEnd,
    final DateTime? currentPeriodStart,
    final DateTime? currentPeriodEnd,
    final String? planName,
    final String? planTier,
    final String? planMonthlyTokenLimit,
    final int? amount,
    final String? currency,
    final String? description,
  }) = _SubscriptionResponse;
}
