import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

class SseSubscription {
  final Dio _dio;
  final String _url;
  final Map<String, String> _headers;
  late BehaviorSubject<SseEvent>? _subject;
  StreamSubscription<String>? _linesSubscription;
  CancelToken? _cancelToken;

  Stream<SseEvent>? get stream => _subject?.stream;

  SseSubscription(this._dio, this._url, {Map<String, String>? headers})
    : _headers = headers ?? {'Accept': 'text/event-stream'} {}

  Future<void> startListening() async {
    _cancelToken = CancelToken();
    _subject = BehaviorSubject<SseEvent>();
    try {
      final response = await _dio.get<ResponseBody>(
        _url,
        cancelToken: _cancelToken,
        options: Options(responseType: ResponseType.stream, headers: _headers),
      );
      print('response: $response');

      final stream = response.data!.stream;
      final utf8Stream = stream.cast<List<int>>().transform(utf8.decoder);
      final lines = utf8Stream.transform(const LineSplitter());

      String? event;
      String? id;
      StringBuffer dataBuffer = StringBuffer();

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
          print('error...');
          // this will be invoked in case of some error occurs in the connection
          // like the server going down
          //  SSE error: HttpException: Connection closed while receiving data, uri = http://192.168.1.2:8080/sse/stream-sse-json
          _subject?.addError(error);
          _subject?.close();
        },
        onDone: () {
          print('done...');
          _subject?.close();
        },
      );
    } catch (e) {
      if (!(_subject?.isClosed ?? true)) {
        _subject?.addError(e);
        await _subject?.close();
      }
    }
  }

  Future<void> stopListening() async {
    print('Stopping SSE and cancelling HTTP request...');

    // Cancel the subscription to the lines stream, stops listening to SSE events
    await _linesSubscription?.cancel();
    _linesSubscription = null;

    // Cancel the Dio HTTP request to close connection to server
    if (!(_cancelToken?.isCancelled ?? true)) {
      _cancelToken?.cancel("SSE stopped by client");
    }

    // Close the BehaviorSubject so no more events will be emitted
    if (!(_subject?.isClosed ?? true)) {
      await _subject?.close();
    }
  }
}

class SseEvent {
  final String event;
  final String data;
  final String? id;

  SseEvent({required this.event, required this.data, this.id});

  @override
  String toString() => 'SseEvent(event: $event, data: $data, id: $id)';
}
