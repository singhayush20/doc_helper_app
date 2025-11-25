import 'package:doc_helper_app/core/common/utils/app_utils.dart';
import 'package:doc_helper_app/feature/plan/domain/enum/plan_info_enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'plan_info.freezed.dart';

@liteFreezed
abstract class PlanInfo with _$PlanInfo {
  const factory PlanInfo({
    final int? userId,
    final int? monthlyLimit,
    final int? currentMonthlyUsage,
    final int? remainingTokens,
    final double? usagePercentage,
    final DateTime? resetDate,
    final AccountType? tier,
    final bool? isActive,
  }) = _PlanInfo;
}
