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
  });

  factory BillingProductInfoDto.fromJson(Map<String, dynamic> json) =>
      _$BillingProductInfoDtoFromJson(json);

  final int? id;
  final String? code;
  final String? displayName;
  final String? tier;
  final int? monthlyTokenLimit;
  final bool? active;
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
class CheckoutSessionResponseDto {
  const CheckoutSessionResponseDto({
    this.providerSubscriptionId,
    this.providerKeyId,
    this.planCode,
    this.priceCode,
  });

  factory CheckoutSessionResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CheckoutSessionResponseDtoFromJson(json);

  final String? providerSubscriptionId;
  final String? providerKeyId;
  final String? planCode;
  final String? priceCode;
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
  });

  factory SubscriptionResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionResponseDtoFromJson(json);

  final String? planCode;
  final String? priceCode;
  final String? status;
  final bool? cancelAtPeriodEnd;
  final DateTime? currentPeriodStart;
  final DateTime? currentPeriodEnd;
}

