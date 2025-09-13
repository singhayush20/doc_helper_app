import 'package:dartz/dartz.dart';
import 'package:doc_helper_app/core/exception_handling/server_exception.dart';
import 'package:doc_helper_app/core/value_objects/value_objects.dart';
import 'package:doc_helper_app/feature/auth/domain/entities/user.dart';

abstract class IAuthFacade {
  Future<Either<ServerException, AppUser?>> getCurrentUser();

  Stream<Either<ServerException, AppUser?>> authStateChanges();

  Future<Either<ServerException, Unit>> signInWithEmailAndPassword({
    required EmailAddress? email,
    required Password? password,
  });

  Future<Either<ServerException, Unit>> signUpUser({
    required EmailAddress? email,
    required Password? password,
  });

  Future<Either<ServerException, Unit>> signOut();
}
