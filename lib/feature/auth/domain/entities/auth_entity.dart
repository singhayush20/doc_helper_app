import 'package:doc_helper_app/core/common/utils/app_utils.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_entity.freezed.dart';

@liteFreezed
abstract class VerificationResponse with _$VerificationResponse {
  const factory VerificationResponse({final bool? success}) =
      _VerificationResponse;
}
