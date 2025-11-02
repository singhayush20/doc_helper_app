import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_doc_dto.g.dart';

@JsonSerializable()
class UserDocDto {
  const UserDocDto({
    this.id,
    this.fileName,
    this.originalFilename,
    this.status,
  });

  factory UserDocDto.fromJson(Map<String, dynamic> json) =>
      _$UserDocDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserDocDtoToJson(this);

  final int? id;
  final String? fileName;
  final String? originalFilename;
  final String? status;
}

@JsonSerializable()
class UserDocListDto {
  const UserDocListDto({
    this.userDocs,
    this.currentPageNumber,
    this.currentPageSize,
    this.isFirst,
    this.isLast,
  });

  factory UserDocListDto.fromJson(Map<String, dynamic> json) =>
      _$UserDocListDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserDocListDtoToJson(this);

  final List<UserDocDto>? userDocs;
  final int? currentPageNumber;
  final int? currentPageSize;
  final bool? isFirst;
  final bool? isLast;
}

@JsonSerializable()
class FileUploadResponseDto {
  const FileUploadResponseDto({this.filePath});

  factory FileUploadResponseDto.fromJson(Map<String, dynamic> json) =>
      _$FileUploadResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FileUploadResponseDtoToJson(this);

  final String? filePath;
}

@JsonSerializable()
class FileDeletionResponseDto {
  const FileDeletionResponseDto({this.deleted});

  factory FileDeletionResponseDto.fromJson(Map<String, dynamic> json) =>
      _$FileDeletionResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FileDeletionResponseDtoToJson(this);

  final bool? deleted;
}
