import 'package:doc_helper_app/core/common/utils/app_utils.dart';
import 'package:doc_helper_app/feature/document_summarizer/domain/entities/doc_summary_enums.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'doc_summary_entity.freezed.dart';

@liteFreezed
abstract class DocumentUploadResponse with _$DocumentUploadResponse {
  const factory DocumentUploadResponse({final int? documentId}) =
      _DocumentUploadResponse;
}

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
