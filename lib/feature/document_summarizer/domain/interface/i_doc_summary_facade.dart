import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:doc_helper_app/core/exception_handling/server_exception.dart';
import 'package:doc_helper_app/feature/document_summarizer/domain/entities/doc_summary_entity.dart';

import '../entities/doc_summary_enums.dart' show SummaryTone, SummaryLength;

abstract class IDocSummaryFacade {
  Future<Either<ServerException, DocumentDetails>> uploadDocument(
    MultipartFile file,
  );

  Future<Either<ServerException, SummaryInfo>> summarizeDocument({
    required int documentId,
    required SummaryTone tone,
    required SummaryLength length,
  });

  Future<Either<ServerException, SummaryListResponse>> getDocumentSummaries(
    int documentId,
  );

  Future<Either<ServerException, DocumentListResponse>> getDocuments();
}
