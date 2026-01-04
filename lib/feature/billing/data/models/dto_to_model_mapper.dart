import 'package:doc_helper_app/feature/billing/data/models/billing_dto.dart';
import 'package:doc_helper_app/feature/billing/domain/entities/billing_entity.dart';

extension BillingProductsInfoListDtoX on BillingProductsInfoListDto {
  BillingProductsInfoList toDomain() => BillingProductsInfoList(
        products: products?.map((e) => e?.toDomain()).toList(),
      );
}

extension BillingProductInfoDtoX on BillingProductInfoDto {
  BillingProductInfo toDomain() => BillingProductInfo(
        id: id,
        code: code,
        displayName: displayName,
        tier: tier,
        monthlyTokenLimit: monthlyTokenLimit,
        active: active,
        features: features,
      );
}

extension BillingPricesResponseDtoX on BillingPricesResponseDto {
  BillingPricesResponse toDomain() => BillingPricesResponse(
        prices: prices?.map((e) => e?.toDomain()).toList(),
      );
}

extension BillingPriceDetailsDtoX on BillingPriceDetailsDto {
  BillingPriceDetails toDomain() => BillingPriceDetails(
        priceCode: priceCode,
        billingPeriod: billingPeriod,
        version: version,
        amount: amount,
        currency: currency,
        providerPlanId: providerPlanId,
        active: active,
      );
}

extension CheckoutSessionInfoDtoX on CheckoutSessionInfoDto {
  CheckoutSessionInfo toDomain() => CheckoutSessionInfo(
        providerSubscriptionId: providerSubscriptionId,
        providerKeyId: providerKeyId,
        planCode: planCode,
        priceCode: priceCode,
      );
}

extension SubscriptionResponseDtoX on SubscriptionResponseDto {
  SubscriptionResponse toDomain() => SubscriptionResponse(
        planCode: planCode,
        priceCode: priceCode,
        status: status,
        cancelAtPeriodEnd: cancelAtPeriodEnd,
        currentPeriodStart: currentPeriodStart,
        currentPeriodEnd: currentPeriodEnd,
        planName: planName,
        planTier: planTier,
        planMonthlyTokenLimit: planMonthlyTokenLimit,
        amount: amount,
        currency: currency,
        description: description,
      );
}
