import 'package:doc_helper_app/core/common/utils/app_utils.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'usage_info.freezed.dart';

@liteFreezed
abstract class UsageInfo with _$UsageInfo {
  const factory UsageInfo({
    final int? userId,
    final int? monthlyLimit,
    final int? currentMonthlyUsage,
    final int? remainingTokens,
    final double? usagePercentage,
    final DateTime? resetDate,
    final bool? isActive,
  }) = _UsageInfo;
}
