import 'package:dartz/dartz.dart';
import 'package:doc_helper_app/core/exception_handling/server_exception.dart';
import 'package:doc_helper_app/core/local_storage/i_local_storage_facade.dart';
import 'package:doc_helper_app/core/value_objects/value_objects.dart';
import 'package:doc_helper_app/env/env_config.dart';
import 'package:doc_helper_app/feature/auth/domain/entities/user.dart';
import 'package:doc_helper_app/feature/auth/domain/interfaces/i_auth_facade.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: IAuthFacade, env: injectionEnv)
class AuthFacadeImpl implements IAuthFacade {
  AuthFacadeImpl(this._firebaseAuth, this._localStorageFacade);

  final FirebaseAuth _firebaseAuth;
  final ILocalStorageFacade _localStorageFacade;

  @override
  Future<Either<ServerException, AppUser?>> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;

    if (user == null) {
      await _localStorageFacade.clear();
    }
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
    required EmailAddress? email,
    required Password? password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email?.input ?? '',
        password: password?.input ?? '',
      );

      final user = userCredential.user;
      if (user == null) {
        return left(const ServerException('User not found!'));
      }
      final idToken = await user.getIdToken();

      if (idToken?.isEmpty ?? true) {
        return left(const ServerException('ID token is empty!'));
      }

      await Future.wait([
        (() => _localStorageFacade.saveUid(uid: user.uid))(),
        (() => _localStorageFacade.saveUserEmail(
          emailAddress: user.email ?? '',
        ))(),
        (() => _localStorageFacade.saveAuthToken(token: idToken ?? ''))(),
        (() => _localStorageFacade.saveLoggedIn(isLoggedIn: true))(),
      ]);

      return right(unit);
    } catch (e) {
      return left(ServerException(e.toString()));
    }
  }

  @override
  Future<Either<ServerException, Unit>> signOut() async {
    _firebaseAuth.signOut();
    await _localStorageFacade.clear();
    return right(unit);
  }
}
