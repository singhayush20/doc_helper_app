import 'package:json_annotation/json_annotation.dart';

part 'user_dto.g.dart';

@JsonSerializable()
class AppUserDto {
  const AppUserDto({
    this.firstName,
    this.lastName,
    this.password,
    this.email,
    this.userId,
    this.emailVerified,
  });

  factory AppUserDto.fromJson(Map<String, dynamic> json) =>
      _$AppUserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AppUserDtoToJson(this);

  final String? firstName;
  final String? lastName;
  final String? password;
  final String? email;
  final String? userId;
  final bool? emailVerified;
}
