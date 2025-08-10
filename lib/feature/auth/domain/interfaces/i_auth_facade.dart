import 'package:dartz/dartz.dart';
import 'package:doc_helper_app/core/exception_handling/ServerException.dart';
import 'package:doc_helper_app/feature/auth/domain/entities/user.dart';

abstract class IAuthFacade {
  Future<Either<ServerException, AppUser?>> getCurrentUser();

  Stream<Either<ServerException, AppUser?>> authStateChanges();

  Future<Either<ServerException, Unit>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<ServerException, Unit>> signOut();
}
