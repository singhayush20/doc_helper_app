class SseEvent {
  SseEvent({this.id, this.event, required this.data});

  final String? id;
  final String? event;
  final String data;
}
