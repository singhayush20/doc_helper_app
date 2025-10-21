import 'package:doc_helper_app/feature/chat/data/models/chat_dto.dart';
import 'package:doc_helper_app/feature/chat/domain/entities/chat_entities.dart';

extension ChatHistoryDtoX on ChatHistoryDto {
  ChatHistory toDomain() => ChatHistory(
        threadId: threadId,
        messages: messages?.map((e) => e.toDomain()).toList(),
      );
}

extension ChatMessageDtoX on ChatMessageDto {
  ChatMessage toDomain() => ChatMessage(
        id: id,
        content: content,
        role: role,
        timestamp: timestamp,
      );
}
