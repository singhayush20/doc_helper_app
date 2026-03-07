import 'package:doc_helper_app/feature/features_page/data/models/feature_dto.dart';
import 'package:doc_helper_app/feature/features_page/domain/entity/features.dart';
import 'package:doc_helper_app/feature/ui_component/data/models/dto_to_entity_mapper.dart';

extension FeatureUsageQuotaDtoX on FeatureUsageQuotaDto {
  FeatureUsageQuota toDomain() => FeatureUsageQuota(
    metric: metric,
    used: used,
    limit: limit,
    resetAt: resetAt,
  );
}

extension ProductFeatureDtoX on ProductFeatureDto {
  ProductFeature toDomain() => ProductFeature(
    code: code,
    name: name,
    featureId: featureId,
    usageMetric: usageMetric,
    featureUsageQuota: featureUsageQuotaDto?.toDomain(),
  );
}

extension ProductFeatureUiDtoX on ProductFeatureUiDto {
  ProductFeatureUi toDomain() =>
      ProductFeatureUi(feature: feature?.toDomain(), ui: ui?.toDomain());
}

extension ProductFeatureListDtoX on ProductFeatureListDto {
  ProductFeatureList toDomain() =>
      ProductFeatureList(features: features?.map((e) => e.toDomain()).toList());
}

extension FeatureUsageInfoDtoX on FeatureUsageInfoDto {
  FeatureUsageInfo toDomain() => FeatureUsageInfo(
    metric: metric,
    used: used,
    limit: limit,
    resetAt: resetAt,
  );
}

extension ProductFeatureUsageInfoDtoX on ProductFeatureUsageInfoDto {
  ProductFeatureUsageInfo toDomain() => ProductFeatureUsageInfo(
    code: code,
    featureId: featureId,
    name: name,
    usageInfo: usageInfo?.toDomain(),
  );
}

extension ProductFeaturesUsageInfoResponseX
    on ProductFeaturesUsageInfoResponse {
  ProductFeaturesUsageInfo toDomain() => ProductFeaturesUsageInfo(
    usageInfo: usageInfo.map((e) => e?.toDomain()).toList(),
  );
}
