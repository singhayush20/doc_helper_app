import 'package:doc_helper_app/common/utils/app_utils.dart';
import 'package:doc_helper_app/core/value_objects/value_objects.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@liteFreezed
abstract class AppUser with _$AppUser {
  const factory AppUser({
    final Name? firstName,
    final Name? lastName,
    final EmailAddress? email,
    final String? userId,
  }) = _AppUser;
}
