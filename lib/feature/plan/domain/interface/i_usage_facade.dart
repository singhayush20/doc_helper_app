import 'package:dartz/dartz.dart';
import 'package:doc_helper_app/core/exception_handling/server_exception.dart';
import 'package:doc_helper_app/feature/plan/domain/models/usage_info.dart';

abstract class IUsageFacade {
  Future<Either<ServerException, UsageInfo?>> getUsageInfo();
}
