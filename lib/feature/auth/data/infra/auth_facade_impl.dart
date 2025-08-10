import 'package:dartz/dartz.dart';
import 'package:doc_helper_app/core/exception_handling/ServerException.dart';
import 'package:doc_helper_app/env/env_config.dart';
import 'package:doc_helper_app/feature/auth/domain/entities/user.dart';
import 'package:doc_helper_app/feature/auth/domain/interfaces/i_auth_facade.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: IAuthFacade, env: injectionEnv)
class AuthFacadeImpl implements IAuthFacade {
  AuthFacadeImpl(this._auth);
  final FirebaseAuth _auth;
  @override
  Future<Either<ServerException, AppUser?>> getCurrentUser() async {
    // final user = _auth.currentUser;
    // return user == null ? null : DomainUser(uid: user.uid, email: user.email);
    return right(null);
  }

  @override
  Stream<Either<ServerException, AppUser?>> authStateChanges() {
    //  return _auth.authStateChanges().map((user) {
    //       if (user == null) return null;
    //       return DomainUser(uid: user.uid, email: user.email);
    //     });
    throw UnimplementedError();
  }

  @override
  Future<Either<ServerException, Unit>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    // await _auth.signInWithEmailAndPassword(email: email, password: password);
    throw UnimplementedError();
  }

  @override
  Future<Either<ServerException, Unit>> signOut() {
    // _auth.signOut();
    throw UnimplementedError();
  }
}
