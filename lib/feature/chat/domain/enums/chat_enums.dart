enum MessageActor {
  user,
  assistant
}

enum MessageEventType {
  start,
  heartbeat,
  message,
  citations,
  done,
  error
}

enum CitationType {
  document,
  web
}
