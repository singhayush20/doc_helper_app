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
import 'package:doc_helper_app/feature/chat/domain/enums/chat_enums.dart';
import 'package:doc_helper_app/feature/chat/domain/interface/i_chat_facade.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

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

  final _uuid = const Uuid();

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

  Future<void> _onStarted(_Started event, Emitter<ChatState> emit) async {
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
    final result = await _chatFacade.getChatHistory(
      documentId: docId,
      page: page,
    );

    _isFetching = false;
    result.fold(
      (exception) {
        final pagingState = state.store.chatPagingState;

        emit(
          ChatState.onChatHistoryFetchError(
            store: state.store.copyWith(
              chatPagingState: pagingState.copyWith(
                error: exception,
                isLoading: false,
              ),
            ),
            exception: exception,
          ),
        );
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

  void _onWebSearchToggled(_OnWebSearchToggled event, Emitter<ChatState> emit) {
    final newStore = state.store.copyWith(
      webSearchEnabled: !state.store.webSearchEnabled,
    );

    emit(ChatState.onWebSearchToggle(store: newStore));
  }

  void _onQueryChanged(_QueryChanged event, Emitter<ChatState> emit) {
    final newStore = state.store.copyWith(
      searchQuery: SearchQuery(event.query),
    );

    emit(ChatState.onQueryUpdate(store: newStore));
  }

  Future<void> _sendMessage(_SendMessage event, Emitter<ChatState> emit) async {
    final query = state.store.searchQuery?.input.trim() ?? '';
    if (query.isEmpty) return;

    final store = state.store;

    final userMessage = ChatMessage(
      id: null,
      role: MessageActor.user,
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

    emit(
      ChatState.onMessageSent(
        store: state.store.copyWith(
          chatHistory: ChatHistory(
            threadId: store.chatHistory?.threadId,
            messages: newUserHistory,
          ),
          chatPagingState: updatedPagingAfterUser,
          searchQuery: SearchQuery(''),
        ),
      ),
    );

    final aiMessage = const ChatMessage(
      role: MessageActor.assistant,
      content: '',
    );

    final newAiHistory = [aiMessage, ...newUserHistory];

    final updatedPagingWithAiMessage = state.store.chatPagingState.copyWith(
      pages: [
        [aiMessage, ...?updatedPagingAfterUser.pages?.first],
        ...?updatedPagingAfterUser.pages?.skip(1),
      ],
    );

    final generationId = createGenerationId();

    emit(
      ChatState.onChatHistoryFetch(
        store: state.store.copyWith(
          chatHistory: ChatHistory(
            threadId: store.chatHistory?.threadId,
            messages: newAiHistory,
          ),
          chatPagingState: updatedPagingWithAiMessage,
          generationId: generationId,
        ),
      ),
    );

    add(const ChatEvent.aiStreamStarted());

    final stream = _chatFacade.getAnswerStreamForQuestion(
      documentId: store.documentId ?? 0,
      question: query,
      webSearch: store.webSearchEnabled,
      generationId: generationId,
    );

    var hasError = false;

    await for (var messageOrError in stream) {
      var isError = false;
      messageOrError.fold(
        (exception) {
          isError = true;
          aiStreamError(
            errorMessage: exception.metaData?.message ?? '',
            errorCode: exception.metaData?.errorCode ?? ErrorCodes.unknownError,
          );
        },
        (response) {
          if (response.event == MessageEventType.message) {
            if (response.message?.isNotEmpty ?? false) {
              aiStreamChunkReceived(chunk: response.message ?? '');
            }
          } else if (response.event == MessageEventType.error) {
            isError = true;
            aiStreamError(
              errorMessage: response.errorMessage ?? '',
              errorCode: response.errorCode ?? '',
            );
          }
        },
      );

      if (isError) {
        hasError = true;
        break;
      }
    }

    if (!hasError) {
      add(const ChatEvent.aiStreamCompleted());
    } else {
      _chatFacade.closeStreams();
    }
  }

  String createGenerationId() => _uuid.v4();

  void _onAiStreamStarted(_AiStreamStarted event, Emitter<ChatState> emit) {
    emit(
      ChatState.onMessageResponseError(
        store: state.store.copyWith(isStreaming: true, streamingError: null),
      ),
    );
  }

  void _onAiStreamChunkReceived(
    _AiStreamChunkReceived event,
    Emitter<ChatState> emit,
  ) {
    final store = state.store;
    final message = [...?store.chatHistory?.messages];

    if (message.isEmpty) return;

    // AI message is always the first message in the list
    final aiIndex = message.indexWhere(
      (msg) => (msg.role == MessageActor.assistant),
    );
    if (aiIndex == -1) return;

    final aiMsg = message[aiIndex];

    final updatedMsg = aiMsg.copyWith(
      content: (aiMsg.content ?? '') + event.chunk,
    );

    message[aiIndex] = updatedMsg;

    final updatedPaging = store.chatPagingState.copyWith(
      pages: [
        [updatedMsg, ...?store.chatPagingState.pages?.first.skip(1)],
        ...?store.chatPagingState.pages?.skip(1),
      ],
    );

    emit(
      ChatState.onChatHistoryFetch(
        store: store.copyWith(
          chatHistory: store.chatHistory?.copyWith(messages: message),
          chatPagingState: updatedPaging,
        ),
      ),
    );
  }

  void _onAiStreamCompleted(_AiStreamCompleted event, Emitter<ChatState> emit) {
    emit(
      ChatState.onChatHistoryFetch(
        store: state.store.copyWith(isStreaming: false),
      ),
    );
  }

  void _onAiStreamError(_AiStreamError event, Emitter<ChatState> emit) {
    final store = state.store;

    const uiMessage = 'Something went wrong. Please try again.';

    final updatedMessages = (store.chatHistory?.messages ?? []).map((message) {
      final isStreamingAssistant =
          message.role == MessageActor.assistant &&
          (message.content == null || (message.content?.isEmpty ?? true));

      if (isStreamingAssistant) {
        return message.copyWith(content: uiMessage, isError: true);
      }
      return message;
    }).toList();

    final pages = store.chatPagingState.pages;
    final updatedPages = pages == null
        ? null
        : [
            [
              for (final message in pages.first)
                (message.role == MessageActor.assistant &&
                        (message.content == null ||
                            (message.content?.isEmpty ?? true)))
                    ? message.copyWith(content: uiMessage, isError: true)
                    : message,
            ],
            ...pages.skip(1),
          ];

    emit(
      ChatState.onMessageResponseError(
        store: store.copyWith(
          isStreaming: false,
          streamingError: event.errorMessage,
          streamingErrorCode: event.errorCode,
          chatHistory: store.chatHistory?.copyWith(messages: updatedMessages),
          chatPagingState: store.chatPagingState.copyWith(pages: updatedPages),
        ),
      ),
    );
  }

  Future<void> _onStopGeneration(
    _StopGeneration event,
    Emitter<ChatState> emit,
  ) async {
    final cancelResponseOrFailure = await _chatFacade.cancelCurrentStream(
      generationId: state.store.generationId ?? '',
    );

    cancelResponseOrFailure.fold(
      (exception) {
        // TODO: Handle gracefully
      },
      (_) {
        final cleanedStore = _removeEmptyAssistantBubble(state.store);

        emit(
          ChatState.onChatHistoryFetch(
            store: cleanedStore.copyWith(
              isStreaming: false,
              generationId: null,
            ),
          ),
        );
      },
    );
  }

  ChatStateStore _removeEmptyAssistantBubble(ChatStateStore store) {
    final historyMessages = [...?store.chatHistory?.messages];
    if (historyMessages.isNotEmpty) {
      // First assistant with empty/null content
      final idx = historyMessages.indexWhere(
        (msg) =>
            msg.role == MessageActor.assistant &&
            (msg.content == null || (msg.content?.isEmpty ?? true)),
      );
      if (idx != -1) {
        historyMessages.removeAt(idx);
      }
    }

    // Fix paging first page
    final pages = [...?store.chatPagingState.pages];
    if (pages.isNotEmpty) {
      final firstPage = [...pages.first];
      if (firstPage.isNotEmpty) {
        final firstMsg = firstPage.first;
        if (firstMsg.role == MessageActor.assistant &&
            (firstMsg.content == null || (firstMsg.content?.isEmpty ?? true))) {
          firstPage.removeAt(0);
          pages[0] = firstPage;
        }
      }
    }

    return store.copyWith(
      chatHistory: store.chatHistory?.copyWith(messages: historyMessages),
      chatPagingState: store.chatPagingState.copyWith(pages: pages),
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
  }) => add(
    ChatEvent.historyLoaded(
      chatHistory: chatHistory,
      page: page,
      isLastPage: isLastPage,
    ),
  );

  void onWebSearchToggled() => add(const ChatEvent.onWebSearchToggled());

  void onQueryChanged({required String query}) =>
      add(ChatEvent.queryChanged(query: query));

  void sendMessage() => add(const ChatEvent.sendMessage());

  void stopGeneration() => add(const ChatEvent.stopGeneration());

  void aiStreamChunkReceived({required String chunk}) =>
      add(ChatEvent.aiStreamChunkReceived(chunk: chunk));

  void aiStreamError({
    required String errorMessage,
    required String errorCode,
  }) => add(
    ChatEvent.aiStreamError(errorMessage: errorMessage, errorCode: errorCode),
  );
}
