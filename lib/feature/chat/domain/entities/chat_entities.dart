
import 'package:doc_helper_app/core/common/utils/app_utils.dart';

part 'chat_entities.freezed.dart';

@liteFreezed
abstract class ChatHistory with _$ChatHistory {
  const factory ChatHistory({
    final String? threadId,
    final List<ChatMessage>? messages,
  }) = _ChatHistory;
}

@liteFreezed
abstract class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    final String? id,
    final String? content,
    final String? role,
    final DateTime? timestamp,
  }) = _ChatMessage;
}
