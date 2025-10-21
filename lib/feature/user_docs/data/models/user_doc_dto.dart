import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_doc_dto.g.dart';

// TODO: Need to be verified and fixed
@JsonSerializable()
class UserDocDto {
  const UserDocDto({
    this.id,
    this.fileName,
    this.status,
  });

  factory UserDocDto.fromJson(Map<String, dynamic> json) =>
      _$UserDocDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserDocDtoToJson(this);

  final int? id;
  final String? fileName;
  final String? status;
}

@JsonSerializable()
class UserDocListDto {
  const UserDocListDto({
    this.docs,
    this.total,
    this.page,
    this.size,
  });

  factory UserDocListDto.fromJson(Map<String, dynamic> json) =>
      _$UserDocListDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserDocListDtoToJson(this);

  @JsonKey(name: 'content')
  final List<UserDocDto>? docs;
  @JsonKey(name: 'totalElements')
  final int? total;
  @JsonKey(name: 'number')
  final int? page;
  final int? size;
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
