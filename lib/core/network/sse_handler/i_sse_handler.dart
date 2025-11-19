import 'package:doc_helper_app/core/network/sse_handler/sse_event.dart';

abstract class ISseHandler {
  Future<void> start({
    required String url,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? body,
  });

  Future<void> stop();

  Stream<SseEvent>? get stream;
}
