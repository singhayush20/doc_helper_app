import 'package:doc_helper_app/core/extensions/extensions.dart';
import 'package:doc_helper_app/feature/chat/data/models/chat_dto.dart';
import 'package:doc_helper_app/feature/chat/domain/entities/chat_entities.dart';
import 'package:doc_helper_app/feature/chat/domain/enums/chat_enums.dart';

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
    role: MessageActor.values.by(role),
    timestamp: timestamp,
    citations: citations?.map((e) => e?.toDomain()).toList(),
  );
}

extension ChatResponseCitationDtoX on ChatResponseCitationDto {
  ChatResponseCitation toDomain() => ChatResponseCitation(
    index: index,
    type: CitationType.values.by(type),
    title: title,
    url: url,
    snippet: snippet,
    page: page,
    score: score,
  );
}
