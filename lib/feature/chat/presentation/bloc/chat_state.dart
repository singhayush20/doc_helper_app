part of 'chat_bloc.dart';

@freezed
sealed class ChatState extends BaseState with _$ChatState {
  const ChatState._();

  const factory ChatState.initial({
    required ChatStateStore store,
  }) = _Initial;

  const factory ChatState.onChatHistoryFetch({
    required ChatStateStore store,
  }) = _OnChatHistoryFetch;

  const factory ChatState.invalidateLoader({
    required ChatStateStore store,
  }) = InvalidateLoader;

  const factory ChatState.onException({
    required ChatStateStore store,
    required Exception exception,
  }) = OnException;

  /// User toggled web search
  const factory ChatState.onWebSearchToggle({
    required ChatStateStore store,
  }) = _OnWebSearchToggle;

  /// Input query updated (single source of truth for text field)
  const factory ChatState.onQueryUpdate({
    required ChatStateStore store,
  }) = OnQueryUpdate;

  /// User message has been appended to history
  const factory ChatState.onMessageSent({
    required ChatStateStore store,
  }) = _OnMessageSent;

  @override
  BaseState getExceptionState(Exception exception) =>
      ChatState.onException(
        store: store.copyWith(loading: false),
        exception: exception,
      );

  @override
  BaseState getLoaderState({required bool loading}) =>
      ChatState.invalidateLoader(store: store.copyWith(loading: loading));
}

@liteFreezed
sealed class ChatStateStore with _$ChatStateStore {
  const factory ChatStateStore({
    required PagingState<int, ChatMessage> chatPagingState,
    ChatHistory? chatHistory,
    @Default(false) bool loading,
    @Default(0) int currentPage,
    @Default(true) bool hasMore,

    // Meta
    int? documentId,
    String? documentName,

    // Input
    SearchQuery? searchQuery,
    @Default(false) bool webSearchEnabled,

    // Streaming state
    @Default(false) bool isStreaming,
    String? streamingError,
  }) = _ChatStateStore;
}
