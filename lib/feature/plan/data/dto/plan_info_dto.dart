import 'package:freezed_annotation/freezed_annotation.dart';

part 'plan_info_dto.g.dart';

@JsonSerializable()
class PlanInfoDto {
  const PlanInfoDto({
    required this.userId,
    required this.monthlyLimit,
    required this.currentMonthlyUsage,
    required this.remainingTokens,
    required this.usagePercentage,
    required this.resetDate,
    required this.tier,
    required this.isActive,
  });

  factory PlanInfoDto.fromJson(Map<String, dynamic> json) =>
      _$PlanInfoDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PlanInfoDtoToJson(this);

  final int? userId;
  final int? monthlyLimit;
  final int? currentMonthlyUsage;
  final int? remainingTokens;
  final double? usagePercentage;
  final DateTime? resetDate;
  final String? tier;
  final bool? isActive;
}
