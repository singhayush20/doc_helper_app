import 'package:dartz/dartz.dart';
import 'package:doc_helper_app/common/constants/enums.dart';
import 'package:doc_helper_app/core/exception_handling/server_exception.dart';
import 'package:doc_helper_app/core/local_storage/i_local_storage_facade.dart';
import 'package:doc_helper_app/core/value_objects/value_objects.dart';
import 'package:doc_helper_app/env/env_config.dart';
import 'package:doc_helper_app/feature/auth/data/models/auth_dto.dart';
import 'package:doc_helper_app/feature/auth/data/models/dto_to_model_mapper.dart';
import 'package:doc_helper_app/feature/auth/domain/entities/auth_entity.dart';
import 'package:doc_helper_app/feature/auth/domain/interfaces/i_auth_facade.dart';
import 'package:doc_helper_app/feature/user/data/models/user_dto.dart';
import 'package:doc_helper_app/feature/user/domain/entity/user.dart';
import 'package:doc_helper_app/network/api_call_handler.dart';
import 'package:doc_helper_app/network/retrofit_api_client.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: IAuthFacade, env: injectionEnv)
class AuthFacadeImpl implements IAuthFacade {
  AuthFacadeImpl(
    this._firebaseAuth,
    this._localStorageFacade,
    this._retrofitApiClient,
    this._apiCallHandler,
  );

  final FirebaseAuth _firebaseAuth;
  final ILocalStorageFacade _localStorageFacade;
  final RetrofitApiClient _retrofitApiClient;
  final ApiCallHandler _apiCallHandler;

  @override
  Future<Either<ServerException, AppUser?>> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;

    if (user == null) {
      await _localStorageFacade.clear();
    }
    return user == null
        ? right(null)
        : right(
            AppUser(userId: user.uid, email: EmailAddress(user.email ?? '')),
          );
  }

  @override
  Stream<Either<ServerException, AppUser?>> authStateChanges() =>
      _firebaseAuth.authStateChanges().map((user) {
        if (user == null) return right(null);
        return right(
          AppUser(userId: user.uid, email: EmailAddress(user.email ?? '')),
        );
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
        return left(
          const ServerException(
            exceptionType: ServerExceptionType.invalidCredentials,
            metaData: ExceptionMetaData(
              errorCode: ErrorCodes.invalidCredentials,
              message: ErrorMessages.invalidCredentialsError,
            ),
          ),
        );
      }
      final idToken = await user.getIdToken();
      if (idToken?.isEmpty ?? true) {
        return left(
          const ServerException(
            exceptionType: ServerExceptionType.invalidCredentials,
            metaData: ExceptionMetaData(
              errorCode: ErrorCodes.invalidCredentials,
              message: ErrorMessages.invalidCredentialsError,
            ),
          ),
        );
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
      return left(
        const ServerException(
          exceptionType: ServerExceptionType.invalidCredentials,
          metaData: ExceptionMetaData(
            errorCode: ErrorCodes.invalidCredentials,
            message: ErrorMessages.invalidCredentialsError,
          ),
        ),
      );
    }
  }

  @override
  Future<Either<ServerException, Unit>> signOut() async {
    await _firebaseAuth.signOut();
    await _localStorageFacade.clear();
    return right(unit);
  }

  @override
  Future<Either<ServerException, Unit>> createUser({
    required EmailAddress? email,
    required Password? password,
  }) async {
    try {
      final uerCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email?.input ?? '',
        password: password?.input ?? '',
      );
      final user = uerCredential.user;
      if (user == null) {
        return left(
          const ServerException(
            exceptionType: ServerExceptionType.signUpFailed,
            metaData: ExceptionMetaData(
              errorCode: ErrorCodes.signUpFailed,
              message: ErrorMessages.signUpFailedError,
            ),
          ),
        );
      }
      final authToken = await user.getIdToken();
      if (authToken?.isEmpty ?? true) {
        return left(
          const ServerException(
            exceptionType: ServerExceptionType.signUpFailed,
            metaData: ExceptionMetaData(
              errorCode: ErrorCodes.signUpFailed,
              message: ErrorMessages.signUpFailedError,
            ),
          ),
        );
      }
      await Future.wait([
        (() => _localStorageFacade.saveUid(uid: user.uid))(),
        (() => _localStorageFacade.saveUserEmail(
          emailAddress: user.email ?? '',
        ))(),
        (() => _localStorageFacade.saveAuthToken(token: authToken ?? ''))(),
        (() => _localStorageFacade.saveLoggedIn(isLoggedIn: true))(),
      ]);
      return right(unit);
    } on FirebaseAuthException catch (e) {
      final errorMessage = _getFirebaseAuthErrorMessage(e.code);
      return left(
        ServerException(
          exceptionType: ServerExceptionType.signUpFailed,
          metaData: ExceptionMetaData(errorCode: e.code, message: errorMessage),
        ),
      );
    } catch (e) {
      return left(
        const ServerException(
          exceptionType: ServerExceptionType.signUpFailed,
          metaData: ExceptionMetaData(
            errorCode: ErrorCodes.signUpFailed,
            message: ErrorMessages.signUpFailedError,
          ),
        ),
      );
    }
  }

  @override
  Future<Either<ServerException, Unit>> signUpUser({
    required Name? firstName,
    required Name? lastName,
    required EmailAddress? email,
    required Password? password,
  }) async {
    final userDto = AppUserDto(
      firstName: firstName?.input,
      lastName: lastName?.input,
      password: password?.input,
      email: email?.input,
    );

    final responseOrError = await _apiCallHandler.handleApi(
      _retrofitApiClient.signUp,
      [userDto],
    );

    return await responseOrError.fold((error) async => left(error), (
      response,
    ) async {
      final refreshedUserToken = await _firebaseAuth.currentUser?.getIdToken(
        true,
      );
      if (refreshedUserToken != null) {
        _localStorageFacade.saveAuthToken(token: refreshedUserToken);
      }
      return right(unit);
    });
  }

  @override
  Future<Either<ServerException, Unit>> sendEmailVerificationOtp({
    required EmailAddress? email,
  }) async {
    final emailVerificationDto = EmailVerificationDto(email: email?.input);
    final responseOrError = await _apiCallHandler.handleApi(
      _retrofitApiClient.sendEmailVerificationOtp,
      [emailVerificationDto],
    );

    return responseOrError.fold(
          (error) => left(error),
          (response) => right(unit),
    );
  }

  @override
  Future<Either<ServerException, VerificationResponse>>
  verifyEmailVerificationOtp({
    required EmailAddress? email,
    required Otp? otp,
  }) async {
    final emailVerificationDto = EmailVerificationDto(
      email: email?.input,
      otp: otp?.input,
    );
    final responseOrError = await _apiCallHandler.handleApi(
      _retrofitApiClient.verifyEmailVerificationOtp,
      [emailVerificationDto],
    );

    return responseOrError.fold((error) => left(error), (response) {
      final dto = VerificationResponseDto.fromJson(response.data);
      return right(dto.toDomain());
    });
  }

  @override
  Future<Either<ServerException, Unit>> sendPasswordResetOtp({
    required EmailAddress? email,
  }) async {
    final emailVerificationDto = EmailVerificationDto(email: email?.input);
    final responseOrError = await _apiCallHandler.handleApi(
      _retrofitApiClient.sendPasswordResetOtp,
      [emailVerificationDto],
    );

    return responseOrError.fold(
          (error) => left(error),
          (response) => right(unit),
    );
  }

  @override
  Future<Either<ServerException, Unit>> resetPassword({
    required EmailAddress? email,
    required Otp? otp,
    required Password? password,
  }) async {
    final passwordResetRequestDto = PasswordResetRequestDto(
      email: email?.input,
      otp: otp?.input,
      password: password?.input,
    );
    final responseOrError = await _apiCallHandler.handleApi(
      _retrofitApiClient.resetPassword,
      [passwordResetRequestDto],
    );

    return responseOrError.fold(
          (error) => left(error),
          (response) => right(unit),
    );
    }

  String _getFirebaseAuthErrorMessage(String code) {
    switch (code) {
      case ErrorCodes.firebaseInvalidEmail:
        return ErrorMessages.firebaseInvalidEmailError;
      case ErrorCodes.firebaseUserDisabled:
        return ErrorMessages.firebaseUserDisabledError;
      case ErrorCodes.firebaseUserNotFound:
        return ErrorMessages.firebaseUserNotFoundError;
      case ErrorCodes.firebaseWrongPassword:
        return ErrorMessages.firebaseWrongPasswordError;
      case ErrorCodes.firebaseEmailAlreadyInUse:
        return ErrorMessages.firebaseEmailAlreadyInUseError;
      case ErrorCodes.firebaseOperationNotAllowed:
        return ErrorMessages.firebaseOperationNotAllowedError;
      case ErrorCodes.firebaseWeakPassword:
        return ErrorMessages.firebaseWeakPasswordError;
      case ErrorCodes.firebaseTooManyRequests:
        return ErrorMessages.firebaseTooManyRequestsError;
      default:
        return ErrorMessages.firebaseDefaultErrorMessage;
    }
  }
}
