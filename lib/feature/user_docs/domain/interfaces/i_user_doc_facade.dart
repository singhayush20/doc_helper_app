import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:doc_helper_app/core/exception_handling/server_exception.dart';
import 'package:doc_helper_app/feature/user_docs/domain/entities/user_doc_entity.dart';

abstract class IUserDocFacade {
  Future<Either<ServerException, FileUploadResponse>> uploadDocument(
    MultipartFile file,
  );

  Future<Either<ServerException, UserDocList>> getAllDocs({
    required int page,
    required int size,
    required String sortField,
    required String direction,
  });

  Future<Either<ServerException, FileDeletionResponse>> deleteDocument(
    int documentId,
  );

  Future<Either<ServerException, UserDocList>> getDocSearchResults({
    required String query,
    required int page,
    required int size,
  });
}
