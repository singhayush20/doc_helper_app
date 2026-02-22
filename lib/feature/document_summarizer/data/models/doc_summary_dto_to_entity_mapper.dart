import 'package:doc_helper_app/core/extensions/extensions.dart';
import 'package:doc_helper_app/feature/document_summarizer/data/models/doc_summary_dto.dart';
import 'package:doc_helper_app/feature/document_summarizer/domain/entities/doc_summary_entity.dart';
import 'package:doc_helper_app/feature/document_summarizer/domain/entities/doc_summary_enums.dart';

extension SummaryMetadataDtoX on SummaryInfoDto {
  SummaryInfo toDomain() => SummaryInfo(
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

extension DocumentDetailsDtoX on DocumentDetailsDto {
  DocumentDetails toDomain() => DocumentDetails(
    documentId: documentId,
    fileName: fileName,
    originalFilename: originalFilename,
    createdAt: createdAt,
  );
}

extension DocumentListResponseDtoX on DocumentListResponseDto {
  DocumentListResponse toDomain() => DocumentListResponse(
    documents: documents?.map((e) => e.toDomain()).toList(),
  );
}
