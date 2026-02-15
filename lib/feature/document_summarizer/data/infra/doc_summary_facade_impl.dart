import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:doc_helper_app/core/exception_handling/server_exception.dart';
import 'package:doc_helper_app/core/network/api_call_handler.dart';
import 'package:doc_helper_app/core/network/retrofit_api_client.dart';
import 'package:doc_helper_app/feature/document_summarizer/data/models/doc_summary_dto.dart';
import 'package:doc_helper_app/feature/document_summarizer/data/models/dto_to_entity_mapper.dart';
import 'package:doc_helper_app/feature/document_summarizer/domain/entities/doc_summary_entity.dart';
import 'package:doc_helper_app/feature/document_summarizer/domain/interface/i_doc_summary_facade.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: IDocSummaryFacade)
class DocSummaryFacadeImpl implements IDocSummaryFacade {
  DocSummaryFacadeImpl(this._apiClient, this._apiCallHandler);

  final RetrofitApiClient _apiClient;
  final ApiCallHandler _apiCallHandler;

  @override
  Future<Either<ServerException, DocumentUploadResponse>> uploadDocument(
    MultipartFile file,
  ) async {
    final responseOrError = await _apiCallHandler.handleApi(
      _apiClient.uploadDoc,
      [file],
    );

    return responseOrError.fold(
      (error) => left(error),
      (response) => right(
        DocumentUploadResponseDto.fromJson(
          response.data as Map<String, dynamic>,
        ).toDomain(),
      ),
    );
  }

  @override
  Future<Either<ServerException, SummaryCreateResponse>> summarizeDocument(
    int documentId,
  ) async {
    final responseOrError = await _apiCallHandler.handleApi(
      _apiClient.summarizeDocument,
      [documentId],
    );

    return responseOrError.fold(
      (error) => left(error),
      (response) => right(
        SummaryCreateResponseDto.fromJson(
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
}
