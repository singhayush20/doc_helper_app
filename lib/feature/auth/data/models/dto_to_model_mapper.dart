import 'package:doc_helper_app/feature/auth/data/models/auth_dto.dart';
import 'package:doc_helper_app/feature/auth/domain/entities/auth_entity.dart';

extension VerificationResponseDtoX on VerificationResponseDto {
  VerificationResponse toDomain() => VerificationResponse(success: success);
}
