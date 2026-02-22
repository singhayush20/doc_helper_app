import 'package:json_annotation/json_annotation.dart';

part 'doc_summary_dto.g.dart';

@JsonSerializable()
class SummaryListResponseDto {
  const SummaryListResponseDto({this.summaries});

  factory SummaryListResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SummaryListResponseDtoFromJson(json);

  final List<SummaryInfoDto>? summaries;
}

@JsonSerializable()
class SummaryInfoDto {
  const SummaryInfoDto({
    this.summaryId,
    this.version,
    this.tone,
    this.length,
    this.tokensUsed,
    this.wordCount,
    this.content,
    this.createdAt,
  });

  factory SummaryInfoDto.fromJson(Map<String, dynamic> json) =>
      _$SummaryInfoDtoFromJson(json);

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

  final int? documentId;
  final String? fileName;
  final String? originalFilename;
  final DateTime? createdAt;
}

@JsonSerializable()
class DocumentSummaryRequestDto {
  const DocumentSummaryRequestDto({
    this.documentId,
    this.tone,
    this.length,
  });

  factory DocumentSummaryRequestDto.fromJson(Map<String, dynamic> json) =>
      _$DocumentSummaryRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentSummaryRequestDtoToJson(this);

  final int? documentId;
  final String? tone;
  final String? length;
}