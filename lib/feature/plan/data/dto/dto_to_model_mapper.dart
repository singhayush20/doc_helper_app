import 'package:doc_helper_app/feature/plan/data/dto/usage_info_dto.dart';
import 'package:doc_helper_app/feature/plan/domain/models/usage_info.dart';

extension PlanInfoDtoX on UsageInfoDto {
  UsageInfo toDomain() => UsageInfo(
    userId: userId,
    monthlyLimit: monthlyLimit,
    currentMonthlyUsage: currentMonthlyUsage,
    remainingTokens: remainingTokens,
    usagePercentage: usagePercentage,
    resetDate: resetDate,
    isActive: isActive,
  );
}
