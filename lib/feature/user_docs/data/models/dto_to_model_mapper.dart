import 'package:doc_helper_app/feature/user_docs/data/models/user_doc_dto.dart';
import 'package:doc_helper_app/feature/user_docs/domain/entities/user_doc_entity.dart';

extension UserDocDtoX on UserDocDto {
  UserDoc toDomain() => UserDoc(
        id: id,
        fileName: fileName,
        status: status,
      );
}

extension UserDocListDtoX on UserDocListDto {
  UserDocList toDomain() => UserDocList(
        docs: docs?.map((e) => e.toDomain()).toList(),
        total: total,
        page: page,
        size: size,
      );
}

extension FileUploadResponseDtoX on FileUploadResponseDto {
  FileUploadResponse toDomain() => FileUploadResponse(filePath: filePath);
}

extension FileDeletionResponseDtoX on FileDeletionResponseDto {
  FileDeletionResponse toDomain() => FileDeletionResponse(deleted: deleted);
}
