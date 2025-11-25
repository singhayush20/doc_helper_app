part of 'chat_bloc.dart';

@freezed
sealed class ChatEvent extends BaseEvent with _$ChatEvent {
  const ChatEvent._() : super();

  const factory ChatEvent.started({
    required int documentId,
    required String documentName,
  }) = _Started;

  const factory ChatEvent.fetchNextPage() = _FetchNextPage;

  // History loaded internally
  const factory ChatEvent.historyLoaded({
    required ChatHistory chatHistory,
    required int page,
    required bool isLastPage,
  }) = _HistoryLoaded;

  const factory ChatEvent.onWebSearchToggled() = _OnWebSearchToggled;

  const factory ChatEvent.queryChanged({
    required String query,
  }) = _QueryChanged;

  const factory ChatEvent.sendMessage() = _SendMessage;

  // SSE streaming events
  const factory ChatEvent.aiStreamStarted() = _AiStreamStarted;

  const factory ChatEvent.aiStreamChunkReceived({
    required String chunk,
  }) = _AiStreamChunkReceived;

  const factory ChatEvent.aiStreamCompleted() = _AiStreamCompleted;

  const factory ChatEvent.aiStreamError({
    required String errorMessage,
    required String errorCode,
  }) = _AiStreamError;

  const factory ChatEvent.stopGeneration() = _StopGeneration;
}
