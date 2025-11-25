import 'package:doc_helper_app/core/extensions/extensions.dart';
import 'package:doc_helper_app/feature/plan/data/dto/plan_info_dto.dart';
import 'package:doc_helper_app/feature/plan/domain/enum/plan_info_enum.dart';
import 'package:doc_helper_app/feature/plan/domain/models/plan_info.dart';

extension PlanInfoDtoX on PlanInfoDto {
  PlanInfo toDomain() => PlanInfo(
    userId: userId,
    monthlyLimit: monthlyLimit,
    currentMonthlyUsage: currentMonthlyUsage,
    remainingTokens: remainingTokens,
    usagePercentage: usagePercentage,
    resetDate: resetDate,
    tier: AccountType.values.by(tier ?? ''),
    isActive: isActive,
  );
}
