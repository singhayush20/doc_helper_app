import 'package:dartz/dartz.dart';
import 'package:doc_helper_app/core/exception_handling/server_exception.dart';
import 'package:doc_helper_app/feature/user_activity/domain/entities/user_activity_model.dart';

abstract class IUserActivityFacade {

  Future<Either<ServerException,UserActivityInfo>> getUserActivityInfo();
}
