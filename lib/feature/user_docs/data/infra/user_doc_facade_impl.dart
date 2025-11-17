import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:doc_helper_app/core/exception_handling/server_exception.dart';
import 'package:doc_helper_app/core/network/api_call_handler.dart';
import 'package:doc_helper_app/core/network/retrofit_api_client.dart';
import 'package:doc_helper_app/env/env_config.dart';
import 'package:doc_helper_app/feature/user_docs/data/models/dto_to_model_mapper.dart';
import 'package:doc_helper_app/feature/user_docs/data/models/user_doc_dto.dart';
import 'package:doc_helper_app/feature/user_docs/domain/entities/user_doc_entity.dart';
import 'package:doc_helper_app/feature/user_docs/domain/interfaces/i_user_doc_facade.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: IUserDocFacade, env: injectionEnv)
class UserDocFacadeImpl implements IUserDocFacade {
  UserDocFacadeImpl(this._retrofitApiClient, this._apiCallHandler);

  final RetrofitApiClient _retrofitApiClient;
  final ApiCallHandler _apiCallHandler;

  @override
  Future<Either<ServerException, FileUploadResponse>> uploadDocument(
    MultipartFile file,
  ) async {
    final responseOrError = await _apiCallHandler.handleApi(
      _retrofitApiClient.uploadDoc,
      [file],
    );

    return responseOrError.fold((error) => left(error), (response) {
      final dto = FileUploadResponseDto.fromJson(response.data);
      return right(dto.toDomain());
    });
  }

  @override
  Future<Either<ServerException, UserDocList>> getAllDocs({
    required int page,
    required int size,
    required String sortField,
    required String direction,
  }) async {
    final responseOrError = await _apiCallHandler.handleApi(
      _retrofitApiClient.getAllDocs,
      [page, size, sortField, direction],
    );

    return responseOrError.fold((error) => left(error), (response) {
      final dto = UserDocListDto.fromJson(response.data);
      return right(dto.toDomain());
    });
  }

  @override
  Future<Either<ServerException, FileDeletionResponse>> deleteDocument(
    int documentId,
  ) async {
    final responseOrError = await _apiCallHandler.handleApi(
      _retrofitApiClient.deleteDocument,
      [documentId],
    );

    return responseOrError.fold((error) => left(error), (response) {
      final dto = FileDeletionResponseDto.fromJson(response.data);
      return right(dto.toDomain());
    });
  }

  @override
  Future<Either<ServerException, UserDocList>> getDocSearchResults({
    required String query,
    required int page,
    required int size,
  }) async {
    final responseOrError = await _apiCallHandler.handleApi(
      _retrofitApiClient.getDocSearchResults,
      [query,page,size],
    );

    return responseOrError.fold((error) => left(error), (response) {
      final dto = UserDocListDto.fromJson(response.data);
      return right(dto.toDomain());
    });
  }
}
