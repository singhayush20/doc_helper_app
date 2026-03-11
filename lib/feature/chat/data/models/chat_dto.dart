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
    required this.citations,
  });

  factory ChatMessageDto.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageDtoFromJson(json);

  final String? id;
  final String? content;
  final String? role;
  final DateTime? timestamp;
  final List<ChatResponseCitationDto?>? citations;
}

@JsonSerializable()
class QuestionAnswerResponseDto {
  const QuestionAnswerResponseDto({
    this.errorMessage,
    this.errorCode,
    this.message,
    this.citations,
  });

  factory QuestionAnswerResponseDto.fromJson(Map<String, dynamic> json) =>
      _$QuestionAnswerResponseDtoFromJson(json);

  final String? message;
  final List<ChatResponseCitationDto?>? citations;
  final String? errorMessage;
  final String? errorCode;
}

@JsonSerializable()
class ChatResponseCitationDto {
  const ChatResponseCitationDto({
    required this.index,
    required this.type,
    required this.title,
    required this.url,
    required this.snippet,
    required this.page,
    required this.score,
  });

  factory ChatResponseCitationDto.fromJson(Map<String, dynamic> json) =>
      _$ChatResponseCitationDtoFromJson(json);

  final int? index;
  final String? type;
  final String? title;
  final String? url;
  final String? snippet;
  final dynamic page;
  final double? score;
}
