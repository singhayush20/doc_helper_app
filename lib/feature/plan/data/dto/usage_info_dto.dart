import 'package:freezed_annotation/freezed_annotation.dart';

part 'usage_info_dto.g.dart';

@JsonSerializable()
class UsageInfoDto {
  const UsageInfoDto({
    required this.userId,
    required this.monthlyLimit,
    required this.currentMonthlyUsage,
    required this.remainingTokens,
    required this.usagePercentage,
    required this.resetDate,
    required this.isActive,
  });

  factory UsageInfoDto.fromJson(Map<String, dynamic> json) =>
      _$UsageInfoDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UsageInfoDtoToJson(this);

  final int? userId;
  final int? monthlyLimit;
  final int? currentMonthlyUsage;
  final int? remainingTokens;
  final double? usagePercentage;
  final DateTime? resetDate;
  final bool? isActive;
}
