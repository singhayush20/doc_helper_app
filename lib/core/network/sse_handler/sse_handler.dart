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

  CancelToken? _cancelToken;
  bool _isRunning = false;

  @override
  Stream<SseEvent>? get stream => _subject?.stream;

  @override
  Future<void> start({
    required String url,
    Map<String, dynamic>? queryParams,
    Map<String,dynamic>? body,
  }) async {
    if (_isRunning) return;
    _isRunning = true;
    _cancelToken = CancelToken();
    _subject = BehaviorSubject<SseEvent>();

    try {
      final resp = await dio.post<ResponseBody>(
        url,
        queryParameters: queryParams,
        data: body,
        options: Options(responseType: ResponseType.stream),
        cancelToken: _cancelToken,
      );

      final byteStream = resp.data!.stream;
      final lineStream = byteStream
          .transform(utf8.decoder as StreamTransformer<Uint8List, dynamic>)
          .transform(const LineSplitter());

      final buffer = <String>[];

      await for (final rawLine in lineStream) {
        if (_cancelToken?.isCancelled ?? false) break;

        final line = rawLine;
        if (line.trim().isEmpty) {
          if (buffer.isNotEmpty) {
            final combined = buffer.join('\n');
            final dataLines = combined
                .split('\n')
                .where((l) => l.startsWith('data:'))
                .map((l) => l.substring(5).trim())
                .toList();
            final data = dataLines.join('\n');
            final eventLine = combined
                .split('\n')
                .firstWhere((l) => l.startsWith('event:'), orElse: () => '');
            final idLine = combined
                .split('\n')
                .firstWhere((l) => l.startsWith('id:'), orElse: () => '');
            final event = eventLine.isNotEmpty
                ? eventLine.substring(6).trim()
                : null;
            final id = idLine.isNotEmpty ? idLine.substring(3).trim() : null;

            final ev = SseEvent(id: id, event: event, data: data);
            _subject?.add(ev);
          }
          buffer.clear();
        } else {
          buffer.add(line);
        }
      }
    } catch (e) {
      _subject?.addError(e);
    } finally {
      _isRunning = false;
      await _subject?.close();
    }
  }

  @override
  Future<void> stop() async {
    _cancelToken?.cancel();
    _isRunning = false;
    _subject?.close();
  }

  Future<void> dispose() async {
    await stop();
    await _subject?.close();
  }
}
