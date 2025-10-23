import 'package:doc_helper_app/core/common/utils/app_utils.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_doc_entity.freezed.dart';

@liteFreezed
abstract class UserDoc with _$UserDoc {
  const factory UserDoc({
    int? id,
    String? fileName,
    String? status,
  }) = _UserDoc;
}

@liteFreezed
abstract class UserDocList with _$UserDocList {
  const factory UserDocList({
    List<UserDoc>? docs,
    int? total,
    int? page,
    int? size,
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
