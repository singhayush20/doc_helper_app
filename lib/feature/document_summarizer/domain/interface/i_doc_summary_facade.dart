import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:doc_helper_app/core/exception_handling/server_exception.dart';
import 'package:doc_helper_app/feature/document_summarizer/domain/entities/doc_summary_entity.dart';

abstract class IDocSummaryFacade {
  Future<Either<ServerException, DocumentUploadResponse>> uploadDocument(
      MultipartFile file);

  Future<Either<ServerException, SummaryCreateResponse>> summarizeDocument(
      int documentId);

  Future<Either<ServerException, SummaryListResponse>> getDocumentSummaries(
      int documentId);
}
