import 'package:doc_helper_app/core/common/constants/enums.dart';

class ExceptionMetaData {
  const ExceptionMetaData({this.errorCode, this.message});
  final String? errorCode;
  final String? message;
}

class ServerException implements Exception {
  const ServerException({required this.exceptionType, this.metaData});

  final ExceptionMetaData? metaData;
  final ServerExceptionType exceptionType;
}

class ErrorCodes {
  ErrorCodes._();
  static const String invalidCredentials = 'E0001';
  static const String signUpFailed = 'E0002';
  static const String unknownError = 'E0003';
  static const String firebaseInvalidEmail = 'invalid-email';
  static const String firebaseUserDisabled = 'user-disabled';
  static const String firebaseUserNotFound = 'user-not-found';
  static const String firebaseWrongPassword = 'wrong-password';
  static const String firebaseEmailAlreadyInUse = 'email-already-in-use';
  static const String firebaseOperationNotAllowed = 'operation-not-allowed';
  static const String firebaseWeakPassword = 'weak-password';
  static const String firebaseTooManyRequests = 'too-many-requests';
}

class ErrorMessages {
  ErrorMessages._();
  static const String invalidCredentialsError = 'Invalid Credentials!';
  static const String signUpFailedError = 'Sign Up Failed!';
  static const String defaultErrorMessage = 'Something went wrong!';
  static const String firebaseInvalidEmailError =
      'The email address is badly formatted.';
  static const String firebaseUserDisabledError =
      'This user has been disabled.';
  static const String firebaseUserNotFoundError =
      'No user found for that email.';
  static const String firebaseWrongPasswordError = 'Wrong password provided.';
  static const String firebaseEmailAlreadyInUseError =
      'This email is already in use by another account.';
  static const String firebaseOperationNotAllowedError =
      'Email/password accounts are not enabled.';
  static const String firebaseWeakPasswordError =
      'The password provided is too weak.';
  static const String firebaseTooManyRequestsError =
      'Too many attempts. Try again later.';
  static const String firebaseDefaultErrorMessage =
      'Authentication failed. Please try again.';
  static const String unknownErrorMessage = 'Something went wrong!';
}
