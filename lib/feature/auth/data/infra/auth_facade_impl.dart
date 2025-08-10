import 'package:dartz/dartz.dart';
import 'package:doc_helper_app/core/exception_handling/ServerException.dart';
import 'package:doc_helper_app/env/env_config.dart';
import 'package:doc_helper_app/feature/auth/domain/entities/user.dart';
import 'package:doc_helper_app/feature/auth/domain/interfaces/i_auth_facade.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: IAuthFacade, env: injectionEnv)
class AuthFacadeImpl implements IAuthFacade {
  AuthFacadeImpl(this._firebaseAuth);

  final FirebaseAuth _firebaseAuth;

  @override
  Future<Either<ServerException, AppUser?>> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    return user == null
        ? right(null)
        : right(AppUser(id: user.uid, email: user.email));
  }

  @override
  Stream<Either<ServerException, AppUser?>> authStateChanges() =>
      _firebaseAuth.authStateChanges().map((user) {
        if (user == null) return right(null);
        return right(AppUser(id: user.uid, email: user.email));
      });

  @override
  Future<Either<ServerException, Unit>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return right(unit);
  }

  @override
  Future<Either<ServerException, Unit>> signOut() async {
    _firebaseAuth.signOut();
    return right(unit);
  }
}
