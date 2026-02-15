import 'package:json_annotation/json_annotation.dart';

part 'doc_summary_dto.g.dart';

@JsonSerializable()
class DocumentUploadResponseDto {
  const DocumentUploadResponseDto({this.documentId});

  factory DocumentUploadResponseDto.fromJson(Map<String, dynamic> json) =>
      _$DocumentUploadResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentUploadResponseDtoToJson(this);

  final int? documentId;
}

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
