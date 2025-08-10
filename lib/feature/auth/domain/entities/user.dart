import 'package:doc_helper_app/common/utils/app_utils.dart';
import 'package:doc_helper_app/feature/auth/data/models/user_dto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@liteFreezed
abstract class AppUser with _$AppUser {
  const factory AppUser({
    final String? id,
    final String? email,
    final String? name,
  }) = _AppUser;

  factory AppUser.fromDto(AppUserDto dto) =>
      AppUser(id: dto.id, email: dto.email, name: dto.name);
}
