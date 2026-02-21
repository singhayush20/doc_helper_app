import 'package:doc_helper_app/core/common/utils/app_utils.dart';
import 'package:doc_helper_app/feature/document_summarizer/domain/entities/doc_summary_enums.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'doc_summary_entity.freezed.dart';

@liteFreezed
abstract class SummaryCreateResponse with _$SummaryCreateResponse {
  const factory SummaryCreateResponse({
    final int? summaryId,
    final int? version,
    final int? tokensUsed,
    final String? content,
    final int? wordCount,
  }) = _SummaryCreateResponse;
}

@liteFreezed
abstract class SummaryListResponse with _$SummaryListResponse {
  const factory SummaryListResponse({final List<SummaryMetadata>? summaries}) =
      _SummaryListResponse;
}

@liteFreezed
abstract class SummaryMetadata with _$SummaryMetadata {
  const factory SummaryMetadata({
    final int? summaryId,
    final int? version,
    final SummaryTone? tone,
    final SummaryLength? length,
    final int? tokensUsed,
    final int? wordCount,
    final String? content,
    final DateTime? createdAt,
  }) = _SummaryMetadata;
}

@liteFreezed
abstract class DocumentListResponse with _$DocumentListResponse {
  const factory DocumentListResponse({final List<DocumentDetails>? documents}) =
      _DocumentListResponse;
}

@liteFreezed
abstract class DocumentDetails with _$DocumentDetails {
  const factory DocumentDetails({
    final int? documentId,
    final String? fileName,
    final String? originalFilename,
    final DateTime? createdAt,
  }) = _DocumentDetails;
}
