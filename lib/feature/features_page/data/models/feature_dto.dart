import 'package:doc_helper_app/feature/ui_component/data/models/ui_config_dtos.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'feature_dto.g.dart';

@JsonSerializable()
class FeatureUsageQuotaDto {
  const FeatureUsageQuotaDto({
    required this.metric,
    required this.used,
    required this.limit,
    required this.resetAt,
  });

  factory FeatureUsageQuotaDto.fromJson(Map<String, dynamic> json) =>
      _$FeatureUsageQuotaDtoFromJson(json);

  final String? metric;
  final int? used;
  final int? limit;
  final DateTime? resetAt;
}

@JsonSerializable()
class ProductFeatureDto {
  const ProductFeatureDto({
    required this.code,
    required this.name,
    required this.featureId,
    required this.usageMetric,
    required this.featureUsageQuotaDto,
  });

  factory ProductFeatureDto.fromJson(Map<String, dynamic> json) =>
      _$ProductFeatureDtoFromJson(json);

  final String? code;
  final String? name;
  final int? featureId;
  final String? usageMetric;
  final FeatureUsageQuotaDto? featureUsageQuotaDto;
}

@JsonSerializable()
class ProductFeatureUiDto {
  const ProductFeatureUiDto({required this.feature, required this.ui});

  factory ProductFeatureUiDto.fromJson(Map<String, dynamic> json) =>
      _$ProductFeatureUiDtoFromJson(json);

  final ProductFeatureDto? feature;
  final UIComponentDto? ui;
}

@JsonSerializable()
class ProductFeatureListDto {
  const ProductFeatureListDto({this.features});

  factory ProductFeatureListDto.fromJson(Map<String, dynamic> json) =>
      _$ProductFeatureListDtoFromJson(json);

  final List<ProductFeatureUiDto>? features;
}
