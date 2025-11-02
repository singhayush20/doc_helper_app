import 'package:doc_helper_app/core/common/utils/app_utils.dart';
import 'package:doc_helper_app/feature/user_docs/domain/entities/user_doc_enums.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_doc_entity.freezed.dart';

@liteFreezed
abstract class UserDoc with _$UserDoc {
  const factory UserDoc({
    int? id,
    String? fileName,
    String? originalFilename,
    DocumentStatus? status,
  }) = _UserDoc;
}

@liteFreezed
abstract class UserDocList with _$UserDocList {
  const factory UserDocList({
    List<UserDoc>? userDocs,
    int? currentPageNumber,
    int? currentPageSize,
    bool? isFirst,
    bool? isLast,
  }) = _UserDocList;
}

@liteFreezed
abstract class FileUploadResponse with _$FileUploadResponse {
  const factory FileUploadResponse({String? filePath}) = _FileUploadResponse;
}

@liteFreezed
abstract class FileDeletionResponse with _$FileDeletionResponse {
  const factory FileDeletionResponse({bool? deleted}) = _FileDeletionResponse;
}
