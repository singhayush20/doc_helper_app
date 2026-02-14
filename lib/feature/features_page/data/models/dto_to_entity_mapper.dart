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
  ProductFeatureUi toDomain() => ProductFeatureUi(
    feature: feature?.toDomain(),
    ui: ui?.toDomain(),
  );
}

extension ProductFeatureListDtoX on ProductFeatureListDto {
  ProductFeatureList toDomain() => ProductFeatureList(
    features: features?.map((e) => e.toDomain()).toList(),
  );
}
