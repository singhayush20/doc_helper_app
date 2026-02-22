import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:doc_helper_app/core/exception_handling/server_exception.dart';
import 'package:doc_helper_app/core/network/api_call_handler.dart';
import 'package:doc_helper_app/core/network/retrofit_api_client.dart';
import 'package:doc_helper_app/feature/document_summarizer/data/models/doc_summary_dto.dart';
import 'package:doc_helper_app/feature/document_summarizer/data/models/doc_summary_dto_to_entity_mapper.dart';
import 'package:doc_helper_app/feature/document_summarizer/domain/entities/doc_summary_entity.dart';
import 'package:doc_helper_app/feature/document_summarizer/domain/entities/doc_summary_enums.dart';
import 'package:doc_helper_app/feature/document_summarizer/domain/interface/i_doc_summary_facade.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: IDocSummaryFacade)
class DocSummaryFacadeImpl implements IDocSummaryFacade {
  DocSummaryFacadeImpl(this._apiClient, this._apiCallHandler);

  final RetrofitApiClient _apiClient;
  final ApiCallHandler _apiCallHandler;

  @override
  Future<Either<ServerException, DocumentDetails>> uploadDocument(
    MultipartFile file,
  ) async {
    final responseOrError = await _apiCallHandler.handleApi(
      _apiClient.uploadDocument,
      [file],
    );

    return responseOrError.fold(
      (error) => left(error),
      (response) => right(
        DocumentDetailsDto.fromJson(
          response.data as Map<String, dynamic>,
        ).toDomain(),
      ),
    );
  }

  @override
  Future<Either<ServerException, SummaryInfo>> summarizeDocument({
    required int documentId,
    required SummaryTone tone,
    required SummaryLength length,
  }) async {
    final dto = DocumentSummaryRequestDto(
      documentId: documentId,
      tone: tone.name.toUpperCase(),
      length: length.name.toUpperCase(),
    );
    final responseOrError = await _apiCallHandler.handleApi(
      _apiClient.summarizeDocument,
      [dto],
    );

    return responseOrError.fold(
      (error) => left(error),
      (response) => right(
        SummaryInfoDto.fromJson(
          response.data as Map<String, dynamic>,
        ).toDomain(),
      ),
    );
  }

  @override
  Future<Either<ServerException, SummaryListResponse>> getDocumentSummaries(
    int documentId,
  ) async {
    final responseOrError = await _apiCallHandler.handleApi(
      _apiClient.getDocumentSummaries,
      [documentId],
    );

    return responseOrError.fold(
      (error) => left(error),
      (response) => right(
        SummaryListResponseDto.fromJson(
          response.data as Map<String, dynamic>,
        ).toDomain(),
      ),
    );
  }

  @override
  Future<Either<ServerException, DocumentListResponse>> getDocuments() async {
    final responseOrError = await _apiCallHandler.handleApi(
      _apiClient.getDocuments,
    );

    return responseOrError.fold(
      (error) => left(error),
      (response) => right(
        DocumentListResponseDto.fromJson(
          response.data as Map<String, dynamic>,
        ).toDomain(),
      ),
    );
  }
}
