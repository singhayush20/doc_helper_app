import 'package:json_annotation/json_annotation.dart';

part 'doc_summary_dto.g.dart';

@JsonSerializable()
class SummaryCreateResponseDto {
  const SummaryCreateResponseDto({
    this.summaryId,
    this.version,
    this.tokensUsed,
    this.content,
    this.wordCount,
  });

  factory SummaryCreateResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SummaryCreateResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SummaryCreateResponseDtoToJson(this);

  final int? summaryId;
  final int? version;
  final int? tokensUsed;
  final String? content;
  final int? wordCount;
}

@JsonSerializable()
class SummaryListResponseDto {
  const SummaryListResponseDto({this.summaries});

  factory SummaryListResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SummaryListResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SummaryListResponseDtoToJson(this);

  final List<SummaryMetadataDto>? summaries;
}

@JsonSerializable()
class SummaryMetadataDto {
  const SummaryMetadataDto({
    this.summaryId,
    this.version,
    this.tone,
    this.length,
    this.tokensUsed,
    this.wordCount,
    this.content,
    this.createdAt,
  });

  factory SummaryMetadataDto.fromJson(Map<String, dynamic> json) =>
      _$SummaryMetadataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SummaryMetadataDtoToJson(this);

  final int? summaryId;
  final int? version;
  final String? tone;
  final String? length;
  final int? tokensUsed;
  final int? wordCount;
  final String? content;
  final DateTime? createdAt;
}

@JsonSerializable()
class DocumentListResponseDto {
  const DocumentListResponseDto({this.documents});

  factory DocumentListResponseDto.fromJson(Map<String, dynamic> json) =>
      _$DocumentListResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentListResponseDtoToJson(this);

  final List<DocumentDetailsDto>? documents;
}

@JsonSerializable()
class DocumentDetailsDto {
  const DocumentDetailsDto({
    this.documentId,
    this.fileName,
    this.originalFilename,
    this.createdAt,
  });

  factory DocumentDetailsDto.fromJson(Map<String, dynamic> json) =>
      _$DocumentDetailsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentDetailsDtoToJson(this);

  final int? documentId;
  final String? fileName;
  final String? originalFilename;
  final DateTime? createdAt;
}
