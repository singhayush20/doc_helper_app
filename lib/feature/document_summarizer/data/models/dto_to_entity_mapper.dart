import 'package:doc_helper_app/core/extensions/extensions.dart';
import 'package:doc_helper_app/feature/document_summarizer/data/models/doc_summary_dto.dart';
import 'package:doc_helper_app/feature/document_summarizer/domain/entities/doc_summary_entity.dart';
import 'package:doc_helper_app/feature/document_summarizer/domain/entities/doc_summary_enums.dart';

extension DocumentUploadResponseDtoX on DocumentUploadResponseDto {
  DocumentUploadResponse toDomain() =>
      DocumentUploadResponse(documentId: documentId);
}

extension SummaryCreateResponseDtoX on SummaryCreateResponseDto {
  SummaryCreateResponse toDomain() => SummaryCreateResponse(
        summaryId: summaryId,
        version: version,
        tokensUsed: tokensUsed,
        content: content,
        wordCount: wordCount,
      );
}

extension SummaryMetadataDtoX on SummaryMetadataDto {
  SummaryMetadata toDomain() => SummaryMetadata(
        summaryId: summaryId,
        version: version,
        tone: SummaryTone.values.by(tone),
        length: SummaryLength.values.by(length),
        tokensUsed: tokensUsed,
        wordCount: wordCount,
        content: content,
        createdAt: createdAt,
      );
}

extension SummaryListResponseDtoX on SummaryListResponseDto {
  SummaryListResponse toDomain() => SummaryListResponse(
        summaries: summaries?.map((e) => e.toDomain()).toList(),
      );
}
