import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';

class SseSubscription {
  final Dio _dio;
  final String _url;
  final Map<String, String> _headers;
  late StreamController<SseEvent> _controller;
  StreamSubscription<String>? _linesSubscription;
  late CancelToken _cancelToken; // Add cancel token
  Stream<SseEvent> get stream => _controller.stream;

  SseSubscription(this._dio, this._url, {Map<String, String>? headers})
    : _headers = headers ?? {'Accept': 'text/event-stream'} {
    _controller = StreamController<SseEvent>(
      onListen: () {
        _cancelToken = CancelToken(); // Initialize cancel token on listen
        _startListening();
      },
      onCancel: () {
        _close();
      },
    );
  }

  Future<void> _startListening() async {
    try {
      final response = await _dio.get<ResponseBody>(
        _url,
        cancelToken: _cancelToken, // Pass cancel token here
        options: Options(responseType: ResponseType.stream, headers: _headers),
      );

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
              if (!_controller.isClosed) {
                _controller.add(
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
          _controller.addError(error);
          _controller.close();
        },
        onDone: () {
          _controller.close();
        },
      );
    } catch (e) {
      if (!_controller.isClosed) {
        _controller.addError(e);
        await _controller.close();
      }
    }
  }

  void _close() {
    print('closing on controller and cancelling HTTP request ...');
    _linesSubscription?.cancel();
    if (!_cancelToken.isCancelled) {
      _cancelToken.cancel("SSE connection closed by client");
    }
    _controller.close();
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
