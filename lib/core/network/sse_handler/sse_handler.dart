import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
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
    } catch (e) {
      _subject?.addError(e);
      _isRunning = false;
      await _subject?.close();
    }
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
