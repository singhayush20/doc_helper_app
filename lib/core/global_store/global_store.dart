import 'package:doc_helper_app/core/common/utils/app_utils.dart';
import 'package:doc_helper_app/feature/billing/domain/entities/billing_entity.dart';
import 'package:doc_helper_app/feature/features_page/domain/entity/features.dart';
import 'package:doc_helper_app/feature/plan/domain/models/usage_info.dart';
import 'package:doc_helper_app/feature/user/domain/entity/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'global_store.freezed.dart';

@liteFreezed
abstract class GlobalStore with _$GlobalStore {
  const factory GlobalStore({
    AppUser? userInfo,
    SubscriptionResponse? subscriptionResponse,
    UsageInfo? usageInfo,
    ProductFeaturesUsageInfo? productFeaturesUsageInfo,
  }) = _GlobalStore;
}
