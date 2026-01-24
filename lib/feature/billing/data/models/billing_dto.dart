import 'package:freezed_annotation/freezed_annotation.dart';

part 'billing_dto.g.dart';

@JsonSerializable()
class BillingProductsInfoListDto {
  const BillingProductsInfoListDto({this.products});

  factory BillingProductsInfoListDto.fromJson(Map<String, dynamic> json) =>
      _$BillingProductsInfoListDtoFromJson(json);

  final List<BillingProductInfoDto?>? products;
}

@JsonSerializable()
class BillingProductInfoDto {
  const BillingProductInfoDto({
    this.id,
    this.code,
    this.displayName,
    this.tier,
    this.monthlyTokenLimit,
    this.active,
    this.features,
  });

  factory BillingProductInfoDto.fromJson(Map<String, dynamic> json) =>
      _$BillingProductInfoDtoFromJson(json);

  final int? id;
  final String? code;
  final String? displayName;
  final String? tier;
  final int? monthlyTokenLimit;
  final bool? active;
  final List<String?>? features;
}

@JsonSerializable()
class BillingPricesResponseDto {
  const BillingPricesResponseDto({this.prices});

  factory BillingPricesResponseDto.fromJson(Map<String, dynamic> json) =>
      _$BillingPricesResponseDtoFromJson(json);

  final List<BillingPriceDetailsDto?>? prices;
}

@JsonSerializable()
class BillingPriceDetailsDto {
  const BillingPriceDetailsDto({
    this.priceCode,
    this.billingPeriod,
    this.version,
    this.amount,
    this.currency,
    this.providerPlanId,
    this.active,
  });

  factory BillingPriceDetailsDto.fromJson(Map<String, dynamic> json) =>
      _$BillingPriceDetailsDtoFromJson(json);

  final String? priceCode;
  final String? billingPeriod;
  final int? version;
  final int? amount;
  final String? currency;
  final String? providerPlanId;
  final bool? active;
}

@JsonSerializable()
class CheckoutSessionInfoDto {
  const CheckoutSessionInfoDto({
    this.providerSubscriptionId,
    this.providerKeyId,
    this.planCode,
    this.priceCode,
    this.amount,
  });

  factory CheckoutSessionInfoDto.fromJson(Map<String, dynamic> json) =>
      _$CheckoutSessionInfoDtoFromJson(json);

  final String? providerSubscriptionId;
  final String? providerKeyId;
  final String? planCode;
  final String? priceCode;
  final double? amount;
}

@JsonSerializable()
class SubscriptionResponseDto {
  const SubscriptionResponseDto({
    this.planCode,
    this.priceCode,
    this.status,
    this.cancelAtPeriodEnd,
    this.currentPeriodStart,
    this.currentPeriodEnd,
    this.planName,
    this.planTier,
    this.planMonthlyTokenLimit,
    this.amount,
    this.currency,
    this.description,
  });

  factory SubscriptionResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionResponseDtoFromJson(json);

  final String? planCode;
  final String? priceCode;
  final String? status;
  final bool? cancelAtPeriodEnd;
  final DateTime? currentPeriodStart;
  final DateTime? currentPeriodEnd;
  final String? planName;
  final String? planTier;
  final int? planMonthlyTokenLimit;
  final int? amount;
  final String? currency;
  final String? description;
}

@JsonSerializable()
class CancelCheckoutDto {
  const CancelCheckoutDto({
    this.paymentFailureErrorCode,
    this.paymentFailureErrorMessage,
  });

  factory CancelCheckoutDto.fromJson(Map<String, dynamic> json) =>
      _$CancelCheckoutDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CancelCheckoutDtoToJson(this);

  final String? paymentFailureErrorCode;
  final String? paymentFailureErrorMessage;
}
