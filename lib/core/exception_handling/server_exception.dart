import 'package:doc_helper_app/common/constants/enums.dart';

class ExceptionMetaData {
  const ExceptionMetaData({required this.errorCode, required this.message});
  final String errorCode;
  final String message;
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
}

class ErrorMessages {
  ErrorMessages._();
  static const String invalidCredentialsError = 'Invalid Credentials!';
  static const String signUpFailedError = 'Sign Up Failed!';
  static const String defaultErrorMessage = 'Something went wrong!';
}
