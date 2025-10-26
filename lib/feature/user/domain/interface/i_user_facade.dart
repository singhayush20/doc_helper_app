import 'package:dartz/dartz.dart';
import 'package:doc_helper_app/core/exception_handling/server_exception.dart';
import 'package:doc_helper_app/feature/user/domain/entity/user.dart';

abstract class IUserFacade {
  Future<Either<ServerException, UserAccountInfo?>> getUserInfo();
}
