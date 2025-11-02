import 'package:doc_helper_app/feature/user_docs/data/models/user_doc_dto.dart';
import 'package:doc_helper_app/feature/user_docs/domain/entities/user_doc_entity.dart';
import 'package:doc_helper_app/feature/user_docs/domain/entities/user_doc_enums.dart';

extension UserDocDtoX on UserDocDto {
  UserDoc toDomain() => UserDoc(
    id: id,
    fileName: fileName,
    originalFilename: originalFilename,
    status: (status?.isNotEmpty ?? false)
        ? DocumentStatus.values.byName(status?.toLowerCase() ?? '')
        : null,
  );
}

extension UserDocListDtoX on UserDocListDto {
  UserDocList toDomain() => UserDocList(
    userDocs: userDocs?.map((e) => e.toDomain()).toList(),
    currentPageNumber: currentPageNumber,
    currentPageSize: currentPageSize,
    first: first,
    last: last,
  );
}

extension FileUploadResponseDtoX on FileUploadResponseDto {
  FileUploadResponse toDomain() => FileUploadResponse(filePath: filePath);
}

extension FileDeletionResponseDtoX on FileDeletionResponseDto {
  FileDeletionResponse toDomain() => FileDeletionResponse(deleted: deleted);
}
