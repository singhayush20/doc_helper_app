import 'package:json_annotation/json_annotation.dart';

part 'user_dto.g.dart';

@JsonSerializable()
class AppUserDto {
  const AppUserDto({
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.email,
    this.userId,
  });

  factory AppUserDto.fromJson(Map<String, dynamic> json) =>
      _$AppUserDtoFromJson(json);

  final String? firstName;
  final String? lastName;
  final String? password;
  final String? email;
  final String? userId;

  Map<String, dynamic> toJson() => _$AppUserDtoToJson(this);
}
