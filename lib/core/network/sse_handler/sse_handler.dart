import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:doc_helper_app/core/common/constants/enums.dart';
import 'package:doc_helper_app/core/exception_handling/server_exception.dart';
import 'package:doc_helper_app/core/network/sse_handler/i_sse_handler.dart';
import 'package:doc_helper_app/core/network/sse_handler/sse_event.dart';
import 'package:doc_helper_app/env/env_config.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@Injectable(as: ISseHandler, env: injectionEnv)
class SseClient implements ISseHandler {
  SseClient(this.dio);

  final Dio dio;

  BehaviorSubject<SseEvent>? _subject;
  StreamSubscription<String>? _linesSubscription;

  CancelToken? _cancelToken;
  bool _isRunning = false;

  @override
  Stream<SseEvent>? get stream => _subject?.stream;

  @override
  Future<void> start({
    required String url,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? body,
  }) async {
    if (_isRunning) return;
    _isRunning = true;
    _cancelToken = CancelToken();
    _subject = BehaviorSubject<SseEvent>();

    try {
      final response = await dio.post<ResponseBody>(
        url,
        queryParameters: queryParams,
        data: body,
        options: Options(
          responseType: ResponseType.stream,
          receiveTimeout: null,
        ),
        cancelToken: _cancelToken,
      );

      final stream = response.data!.stream;
      final utf8Stream = stream.cast<List<int>>().transform(utf8.decoder);
      final lines = utf8Stream.transform(const LineSplitter());

      String? event;
      String? id;
      final dataBuffer = StringBuffer();

      _linesSubscription = lines.listen(
            (line) {
          line = line.trim();
          if (line.isEmpty) {
            if (dataBuffer.isNotEmpty) {
              if (!(_subject?.isClosed ?? true)) {
                _subject?.add(
                  SseEvent(
                    event: event ?? 'message',
                    data: dataBuffer.toString().trim(),
                    id: id,
                  ),
                );
              }
              event = null;
              id = null;
              dataBuffer.clear();
            }
          } else if (line.startsWith('event:')) {
            event = line.substring(6).trim();
          } else if (line.startsWith('data:')) {
            dataBuffer.writeln(line.substring(5).trim());
          } else if (line.startsWith('id:')) {
            id = line.substring(3).trim();
          }
        },
        onError: (error) {
          _subject?.addError(error);
          _subject?.close();
        },
        onDone: () async {
          _isRunning = false;
          await _subject?.close();
        },
      );
    } on DioException catch (e) {
      final serverException = await _mapDioExceptionToServerException(e);
      _subject?.addError(serverException);
      _isRunning = false;
      await _subject?.close();
    } catch (e) {
      _subject?.addError(e);
      _isRunning = false;
      await _subject?.close();
    }
  }

  Future<ServerException> _mapDioExceptionToServerException(
      DioException error,
      ) async {
    String? message;
    String? errorCode;

    final response = error.response;
    if (response != null) {
      final data = response.data;

      try {
        if (data is Map<String, dynamic>) {
          // Normal JSON body
          message = data['message'] as String?;
          errorCode = data['code'] as String? ?? data['errorCode'] as String?;
        } else if (data is String) {
          // Raw string; try JSON decode
          final decoded = jsonDecode(data);
          if (decoded is Map<String, dynamic>) {
            message = decoded['message'] as String?;
            errorCode =
                decoded['code'] as String? ?? decoded['errorCode'] as String?;
          } else {
            message ??= data;
          }
        } else if (data is ResponseBody) {
          // Stream body; read it fully and decode
          final text = await data.stream
              .cast<List<int>>()
              .transform(utf8.decoder)
              .join();
          try {
            final decoded = jsonDecode(text);
            if (decoded is Map<String, dynamic>) {
              message = decoded['message'] as String?;
              errorCode = decoded['code'] as String? ??
                  decoded['errorCode'] as String?;
            } else {
              message ??= text;
            }
          } catch (_) {
            message ??= text;
          }
        }
      } catch (_) {
        // Swallow parsing errors, fallback below
      }
    }

    message ??= error.message ?? 'Unknown error occurred';
    return ServerException(
      exceptionType: ServerExceptionType.apiError,
      metaData: ExceptionMetaData(
        message: message,
        errorCode: errorCode,
      ),
    );
  }


  @override
  Future<void> stop() async {
    _cancelToken?.cancel();
    _isRunning = false;
    _subject?.close();
    await _linesSubscription?.cancel();
    _linesSubscription = null;
  }

  Future<void> dispose() async {
    await stop();
    await _subject?.close();
  }
}
