import 'package:dartz/dartz.dart';
import 'package:doc_helper_app/core/exception_handling/server_exception.dart';

abstract class IDocActionFacade {
  Future<Either<ServerException, Unit>> shareSummaryAsText({
    required String content,
    required String subject,
  });

  Future<Either<ServerException, String?>> saveSummaryAsPdf({
    required String content,
    required String fileName,
  });
}
