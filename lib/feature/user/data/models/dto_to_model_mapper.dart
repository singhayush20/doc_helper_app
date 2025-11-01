import 'package:doc_helper_app/core/value_objects/value_objects.dart';
import 'package:doc_helper_app/feature/user/data/models/user_dto.dart';
import 'package:doc_helper_app/feature/user/domain/entity/user.dart';

extension AppUserDtoX on AppUserDto {
  AppUser toDomain() => AppUser(
    firstName: (firstName?.isNotEmpty ?? false) ? Name(firstName ?? '') : null,
    lastName: (lastName?.isNotEmpty ?? false) ? Name(lastName ?? '') : null,
    email: (email?.isNotEmpty ?? false) ? EmailAddress(email ?? '') : null,
    emailVerified: emailVerified,
  );
}
