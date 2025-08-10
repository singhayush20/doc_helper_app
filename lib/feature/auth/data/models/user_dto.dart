import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_dto.g.dart';

@JsonSerializable()
class AppUserDto {
  AppUserDto({this.id, this.email, this.name});

  final String? id;
  final String? email;
  final String? name;

  Map<String, dynamic> toJson() => _$AppUserDtoToJson(this);
}
