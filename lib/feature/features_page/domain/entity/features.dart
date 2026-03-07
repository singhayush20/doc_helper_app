import 'package:doc_helper_app/core/common/utils/app_utils.dart';
import 'package:doc_helper_app/feature/ui_component/domain/entities/ui_config_entities.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'features.freezed.dart';

@liteFreezed
abstract class FeatureUsageQuota with _$FeatureUsageQuota {
  const factory FeatureUsageQuota({
    final String? metric,
    final int? used,
    final int? limit,
    final DateTime? resetAt,
  }) = _FeatureUsageQuota;
}

@liteFreezed
abstract class ProductFeature with _$ProductFeature {
  const factory ProductFeature({
    final String? code,
    final String? name,
    final int? featureId,
    final String? usageMetric,
    final FeatureUsageQuota? featureUsageQuota,
  }) = _ProductFeature;
}

@liteFreezed
abstract class ProductFeatureUi with _$ProductFeatureUi {
  const factory ProductFeatureUi({
    final ProductFeature? feature,
    final UIComponent? ui,
  }) = _ProductFeatureUi;
}

@liteFreezed
abstract class ProductFeatureList with _$ProductFeatureList {
  const factory ProductFeatureList({
    final List<ProductFeatureUi?>? features,
  }) = _ProductFeatureList;
}

@liteFreezed
abstract class FeatureUsageInfo with _$FeatureUsageInfo {
  const factory FeatureUsageInfo({
    final String? metric,
    final int? used,
    final int? limit,
    final DateTime? resetAt,
  }) = _FeatureUsageInfo;
}

@liteFreezed
abstract class ProductFeatureUsageInfo with _$ProductFeatureUsageInfo {
  const factory ProductFeatureUsageInfo({
    final String? code,
    final int? featureId,
    final String? name,
    final FeatureUsageInfo? usageInfo,
  }) = _ProductFeatureUsageInfo;
}

@liteFreezed
abstract class ProductFeaturesUsageInfo with _$ProductFeaturesUsageInfo {
  const factory ProductFeaturesUsageInfo({
    final List<ProductFeatureUsageInfo?>? usageInfo,
  }) = _ProductFeaturesUsageInfo;
}
