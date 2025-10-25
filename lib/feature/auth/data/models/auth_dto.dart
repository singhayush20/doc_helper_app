import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_dto.g.dart';

@JsonSerializable()
class EmailVerificationDto {
  const EmailVerificationDto({this.email, this.otp});

  factory EmailVerificationDto.fromJson(Map<String, dynamic> json) =>
      _$EmailVerificationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$EmailVerificationDtoToJson(this);

  final String? email;
  final String? otp;
}

@JsonSerializable()
class PasswordResetRequestDto {
  const PasswordResetRequestDto({this.otp, this.password, this.email});

  factory PasswordResetRequestDto.fromJson(Map<String, dynamic> json) =>
      _$PasswordResetRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PasswordResetRequestDtoToJson(this);

  final String? otp;
  final String? password;
  final String? email;
}

@JsonSerializable()
class VerificationResponseDto {
  const VerificationResponseDto({required this.success});

  factory VerificationResponseDto.fromJson(Map<String, dynamic> json) =>
      _$VerificationResponseDtoFromJson(json);

  final bool? success;
}
