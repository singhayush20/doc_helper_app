import 'package:doc_helper_app/common/utils/app_utils.dart';

part 'auth_entity.freezed.dart';

@liteFreezed
abstract class VerificationResponse with _$VerificationResponse {
  const factory VerificationResponse({final bool? success}) =
      _VerificationResponse;
}
