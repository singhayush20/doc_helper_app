import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_dto.g.dart';

@JsonSerializable()
class ChatRequestDto {
  const ChatRequestDto({required this.documentId, required this.question});

  factory ChatRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ChatRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ChatRequestDtoToJson(this);

  final int? documentId;
  final String? question;
}

@JsonSerializable()
class ChatHistoryDto {
  const ChatHistoryDto({required this.threadId, required this.messages});

  factory ChatHistoryDto.fromJson(Map<String, dynamic> json) =>
      _$ChatHistoryDtoFromJson(json);

  final String? threadId;
  final List<ChatMessageDto>? messages;
}

@JsonSerializable()
class ChatMessageDto {
  const ChatMessageDto({
    required this.id,
    required this.content,
    required this.role,
    required this.timestamp,
  });

  factory ChatMessageDto.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageDtoFromJson(json);

  final String? id;
  final String? content;
  final String? role;
  final DateTime? timestamp;
}
