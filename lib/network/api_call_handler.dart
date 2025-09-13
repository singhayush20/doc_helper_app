import 'package:dartz/dartz.dart' show Either, right, left;
import 'package:dio/dio.dart';
import 'package:doc_helper_app/common/constants/enums.dart';
import 'package:doc_helper_app/core/exception_handling/server_exception.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/dio.dart';

@singleton
class ApiCallHandler {
  Future<Either<ServerException, HttpResponse>> handleApi(
    Function func,
    List<dynamic> args,
  ) async {
    try {
      final response = await Function.apply(func, args) as HttpResponse;
      return right(response);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.receiveTimeout) {
        return left(
          const ServerException(
            exceptionType: ServerExceptionType.receiveTimeout,
            metaData: ExceptionMetaData(
              message: ErrorMessages.defaultErrorMessage,
            ),
          ),
        );
      } else if (e.type == DioExceptionType.sendTimeout) {
        return left(
          const ServerException(
            exceptionType: ServerExceptionType.requestTimeout,
            metaData: ExceptionMetaData(
              message: ErrorMessages.defaultErrorMessage,
            ),
          ),
        );
      } else if (e.type == DioExceptionType.connectionTimeout) {
        return left(
          const ServerException(
            exceptionType: ServerExceptionType.connectionTimeout,
            metaData: ExceptionMetaData(
              message: ErrorMessages.defaultErrorMessage,
            ),
          ),
        );
      } else if (e.type == DioExceptionType.badResponse) {
        final errorResponse = e.response?.data as Map<String, dynamic>?;
        final errorCode = errorResponse?['errorCode'];
        final message = errorResponse?['message'];
        return left(
          ServerException(
            exceptionType: ServerExceptionType.badRequest,
            metaData: ExceptionMetaData(errorCode: errorCode, message: message),
          ),
        );
      }

      return left(
        const ServerException(
          exceptionType: ServerExceptionType.unknown,
          metaData: ExceptionMetaData(
            message: ErrorMessages.defaultErrorMessage,
          ),
        ),
      );
    } catch (e) {
      return left(
        const ServerException(
          exceptionType: ServerExceptionType.unknown,
          metaData: ExceptionMetaData(
            message: ErrorMessages.defaultErrorMessage,
          ),
        ),
      );
    }
  }
}
