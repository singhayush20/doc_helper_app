import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:doc_helper_app/core/common/base_bloc/base_bloc.dart';
import 'package:doc_helper_app/core/common/base_bloc/base_event.dart';
import 'package:doc_helper_app/core/common/base_bloc/base_state.dart';
import 'package:doc_helper_app/core/common/constants/app_constants.dart';
import 'package:doc_helper_app/core/common/utils/app_utils.dart';
import 'package:doc_helper_app/core/exception_handling/server_exception.dart';
import 'package:doc_helper_app/core/value_objects/value_objects.dart';
import 'package:doc_helper_app/feature/chat/domain/entities/chat_entities.dart';
import 'package:doc_helper_app/feature/chat/domain/interface/i_chat_facade.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';

part 'chat_event.dart';
part 'chat_state.dart';
part 'chat_bloc.freezed.dart';

@injectable
class ChatBloc extends BaseBloc<ChatEvent, ChatState> {
  ChatBloc(this._chatFacade)
      : super(
    ChatState.initial(
      store: ChatStateStore(
        chatPagingState: PagingState<int, ChatMessage>(),
      ),
    ),
  );

  final IChatFacade _chatFacade;

  bool _isFetching = false;
  static const int _pageSize = 10;

  @override
  void handleEvents() {
    on<_Started>(_onStarted);
    on<_FetchNextPage>(_onFetchNextPage);
    on<_HistoryLoaded>(_onHistoryLoaded);
    on<_OnWebSearchToggled>(_onWebSearchToggled);
    on<_QueryChanged>(_onQueryChanged);
    on<_SendMessage>(_sendMessage);
    on<_AiStreamStarted>(_onAiStreamStarted);
    on<_AiStreamChunkReceived>(_onAiStreamChunkReceived);
    on<_AiStreamCompleted>(_onAiStreamCompleted);
    on<_AiStreamError>(_onAiStreamError);
    on<_StopGeneration>(_onStopGeneration);
  }

  Future<void> _onStarted(
      _Started event,
      Emitter<ChatState> emit,
      ) async {
    emit(
      ChatState.initial(
        store: state.store.copyWith(
          documentId: event.documentId,
          documentName: event.documentName,
          chatPagingState: PagingState<int, ChatMessage>(),
        ),
      ),
    );

    invalidateLoader(emit, loading: true);
    await _fetchPage(page: 0, emit: emit);
  }

  Future<void> _onFetchNextPage(
      _FetchNextPage event,
      Emitter<ChatState> emit,
      ) async {
    if (_isFetching) return;
    if (!state.store.hasMore) return;

    final nextPage = state.store.currentPage + 1;
    await _fetchPage(page: nextPage, emit: emit);
  }

  Future<void> _fetchPage({
    required int page,
    required Emitter<ChatState> emit,
  }) async {
    if (_isFetching) return;
    _isFetching = true;

    final docId = state.store.documentId ?? 0;
    final result =
    await _chatFacade.getChatHistory(documentId: docId, page: page);

    _isFetching = false;

    result.fold(
          (ServerException exception) {
       // TODO: Handle error
      },
          (ChatHistory history) {
        final messages = history.messages ?? [];
        final isLastPage = messages.isEmpty || messages.length < _pageSize;

        onHistoryLoaded(
          chatHistory: history,
          page: page,
          isLastPage: isLastPage,
        );
      },
    );
  }

  Future<void> _onHistoryLoaded(
      _HistoryLoaded event,
      Emitter<ChatState> emit,
      ) async {
    final store = state.store;

    final historyMessages = event.chatHistory.messages ?? [];
    final oldPaging = store.chatPagingState;

    final updatedPages = <List<ChatMessage>>[
      if (event.page > 0) ...(oldPaging.pages ?? []),
      historyMessages,
    ];

    final updatedPaging = oldPaging.copyWith(
      isLoading: false,
      error: null,
      hasNextPage: !event.isLastPage,
      pages: updatedPages,
      keys: [...?oldPaging.keys, event.page],
    );

    final merged = event.page == 0
        ? historyMessages
        : [...historyMessages, ...?store.chatHistory?.messages];

    final newStore = store.copyWith(
      chatHistory: ChatHistory(
        threadId: event.chatHistory.threadId ?? store.chatHistory?.threadId,
        messages: merged,
      ),
      chatPagingState: updatedPaging,
      currentPage: event.page,
      hasMore: !event.isLastPage,
      loading: false,
    );

    emit(ChatState.onChatHistoryFetch(store: newStore));
  }

  void _onWebSearchToggled(
      _OnWebSearchToggled event,
      Emitter<ChatState> emit,
      ) {
    final newStore = state.store.copyWith(
      webSearchEnabled: !state.store.webSearchEnabled,
    );

    emit(ChatState.onWebSearchToggle(store: newStore));
  }

  void _onQueryChanged(
      _QueryChanged event,
      Emitter<ChatState> emit,
      ) {
    final newStore = state.store.copyWith(
      searchQuery: SearchQuery(event.query),
    );

    emit(ChatState.onQueryUpdate(store: newStore));
  }

  Future<void> _sendMessage(
      _SendMessage event,
      Emitter<ChatState> emit,
      ) async {
    final query = state.store.searchQuery?.input.trim() ?? '';
    if (query.isEmpty) return;

    final store = state.store;

    // 1) Add user message
    final userMessage = ChatMessage(
      id: null,
      role: 'user',
      content: query,
    );

    final newUserHistory = [userMessage, ...?store.chatHistory?.messages];

    final currentFirstPage = store.chatPagingState.pages?.elementAtOrNull(0);

    final updatedPagingAfterUser = store.chatPagingState.copyWith(
      pages: [
        [userMessage, ...?currentFirstPage],
        ...?store.chatPagingState.pages?.skip(1),
      ],
    );

    final storeAfterUser = store.copyWith(
      chatHistory: ChatHistory(
        threadId: store.chatHistory?.threadId,
        messages: newUserHistory,
      ),
      chatPagingState: updatedPagingAfterUser,
      // clear query in store
      searchQuery: SearchQuery(''),
    );

    // 2) Emit message-sent and query-update so UI clears the field
    emit(ChatState.onMessageSent(store: storeAfterUser));
    emit(ChatState.onQueryUpdate(store: storeAfterUser));

    // 3) Add placeholder AI message
    final aiMessage = const ChatMessage(
      id: null,
      role: 'assistant',
      content: '',
    );

    final newAiHistory = [aiMessage, ...newUserHistory];

    final updatedPagingWithAi = storeAfterUser.chatPagingState.copyWith(
      pages: [
        [aiMessage, ...?updatedPagingAfterUser.pages?.first],
        ...?updatedPagingAfterUser.pages?.skip(1),
      ],
    );

    final storeWithAi = storeAfterUser.copyWith(
      chatHistory: ChatHistory(
        threadId: store.chatHistory?.threadId,
        messages: newAiHistory,
      ),
      chatPagingState: updatedPagingWithAi,
    );

    emit(ChatState.onChatHistoryFetch(store: storeWithAi));

    // 4) Start streaming
    add(const ChatEvent.aiStreamStarted());

    final stream = _chatFacade.getAnswerStreamForQuestion(
      documentId: store.documentId ?? 0,
      question: query,
      webSearch: store.webSearchEnabled,
    );

    await for (final either in stream) {
      await either.fold(
            (ServerException exception) async {
          add(
            ChatEvent.aiStreamError(
              errorMessage: exception.metaData?.message ?? 'Unknown error',
            ),
          );
        },
            (QuestionAnswerResponse res) async {
          if (res.message?.isNotEmpty ?? false) {
            add(
              ChatEvent.aiStreamChunkReceived(
                chunk: res.message ?? '',
              ),
            );
          }
        },
      );
    }

    add(const ChatEvent.aiStreamCompleted());
  }

  void _onAiStreamStarted(
      _AiStreamStarted event,
      Emitter<ChatState> emit,
      ) {
    emit(
      ChatState.onChatHistoryFetch(
        store: state.store.copyWith(
          isStreaming: true,
          streamingError: null,
        ),
      ),
    );
  }

  void _onAiStreamChunkReceived(
      _AiStreamChunkReceived event,
      Emitter<ChatState> emit,
      ) {
    final store = state.store;
    final msgs = [...?store.chatHistory?.messages];

    if (msgs.isEmpty) return;

    // AI message is always the first message in the list
    final aiIndex = msgs.indexWhere(
          (m) => (m.role ?? '').toLowerCase() == 'assistant',
    );
    if (aiIndex == -1) return;

    final aiMsg = msgs[aiIndex];

    final updatedMsg = aiMsg.copyWith(
      content: (aiMsg.content ?? '') + event.chunk,
    );

    msgs[aiIndex] = updatedMsg;

    final updatedPaging = store.chatPagingState.copyWith(
      pages: [
        [
          updatedMsg,
          ...?store.chatPagingState.pages?.first.skip(1),
        ],
        ...?store.chatPagingState.pages?.skip(1),
      ],
    );

    emit(
      ChatState.onChatHistoryFetch(
        store: store.copyWith(
          chatHistory: store.chatHistory?.copyWith(messages: msgs),
          chatPagingState: updatedPaging,
        ),
      ),
    );
  }

  void _onAiStreamCompleted(
      _AiStreamCompleted event,
      Emitter<ChatState> emit,
      ) {
    emit(
      ChatState.onChatHistoryFetch(
        store: state.store.copyWith(isStreaming: false),
      ),
    );
  }

  void _onAiStreamError(
      _AiStreamError event,
      Emitter<ChatState> emit,
      ) {
    emit(
      ChatState.onChatHistoryFetch(
        store: state.store.copyWith(
          isStreaming: false,
          streamingError: event.errorMessage,
        ),
      ),
    );
  }

  Future<void> _onStopGeneration(
      _StopGeneration event,
      Emitter<ChatState> emit,
      ) async {
    await _chatFacade.cancelCurrentStream();

    emit(
      ChatState.onChatHistoryFetch(
        store: state.store.copyWith(isStreaming: false),
      ),
    );
  }

  @override
  void started({Map<String, dynamic>? args}) {
    final docId = args?[AppConstants.documentId] as String? ?? '0';
    final documentName = args?[AppConstants.documentName] as String? ?? '';

    add(
      ChatEvent.started(
        documentId: int.tryParse(docId) ?? 0,
        documentName: documentName,
      ),
    );
  }

  void onHistoryLoaded({
    required bool isLastPage,
    required int page,
    required ChatHistory chatHistory,
  }) =>
      add(
        ChatEvent.historyLoaded(
          chatHistory: chatHistory,
          page: page,
          isLastPage: isLastPage,
        ),
      );

  void onWebSearchToggled() =>
      add(const ChatEvent.onWebSearchToggled());

  void onQueryChanged({required String query}) =>
      add(ChatEvent.queryChanged(query: query));

  void sendMessage() => add(const ChatEvent.sendMessage());

  void stopGeneration() => add(const ChatEvent.stopGeneration());
}
