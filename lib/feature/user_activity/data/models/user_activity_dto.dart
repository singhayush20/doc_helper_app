import 'package:json_annotation/json_annotation.dart';

part 'user_activity_dto.g.dart';

@JsonSerializable()
class UserActivityInfoDto {
  const UserActivityInfoDto({
    this.userActivities,
  });

  factory UserActivityInfoDto.fromJson(Map<String, dynamic> json) =>
      _$UserActivityInfoDtoFromJson(json);

  final List<UserActivityDto?>? userActivities;
}

@JsonSerializable()
class UserActivityDto {
  const UserActivityDto({
    this.documentId,
    this.dominantActivity,
    this.dominantAt,
    this.lastAction,
    this.fileName,
  });

  factory UserActivityDto.fromJson(Map<String, dynamic> json) =>
      _$UserActivityDtoFromJson(json);

  final int? documentId;
  final String? dominantActivity;
  final DateTime? dominantAt;
  final String? lastAction;
  final String? fileName;
}
