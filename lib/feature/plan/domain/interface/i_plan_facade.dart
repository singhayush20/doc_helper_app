import 'package:dartz/dartz.dart';
import 'package:doc_helper_app/core/exception_handling/server_exception.dart';
import 'package:doc_helper_app/feature/plan/domain/models/plan_info.dart';

abstract class IPlanFacade {
  Future<Either<ServerException, PlanInfo?>> getUsageInfo();
}
