part of 'chat_page.dart';

class _ChatForm extends StatelessWidget {
  const _ChatForm();

  @override
  Widget build(BuildContext context) => BlocBuilder<ChatBloc, ChatState>(
    builder: (context, state) => Container(
      color: DsColors.backgroundPrimary,
      child: const Column(
        children: [
          Expanded(child: ChatListView()),
          ChatInputBar(),
        ],
      ),
    ),
  );
}


class ChatListView extends StatelessWidget {
  const ChatListView({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) => PagedListView<int, ChatMessage>(
          reverse: true,
          padding: EdgeInsets.all(DsSpacing.radialSpace12),
          state: state.store.chatPagingState,
          fetchNextPage: () => getBloc<ChatBloc>(context)
              .add(const ChatEvent.fetchNextPage()),
          builderDelegate: PagedChildBuilderDelegate<ChatMessage>(
            itemBuilder: (_, msg, __) {
              final isAssistant =
                  (msg.role ?? '').toLowerCase() == 'assistant';
              final isEmpty = msg.content?.isEmpty ?? true;
              final showTyping =
                  state.store.isStreaming && isAssistant && isEmpty;

              return ChatMessageBubble(
                message: msg,
                showTyping: showTyping,
              );
            },
            firstPageProgressIndicatorBuilder: (_) =>
            const Center(child: CircularProgressIndicator()),
            newPageProgressIndicatorBuilder: (_) =>
            const Center(child: CircularProgressIndicator()),
            noItemsFoundIndicatorBuilder: (_) =>
            const Center(
              child: DsText.bodyLarge(data: 'No messages yet'),
            ),
            noMoreItemsIndicatorBuilder: (_) =>
            const SizedBox.shrink(),
          ),
        ),
      );
}

class ChatMessageBubble extends StatelessWidget {
  const ChatMessageBubble({
    super.key,
    required this.message,
    this.showTyping = false,
  });

  final ChatMessage message;
  final bool showTyping;

  @override
  Widget build(BuildContext context) {
    final isUser = (message.role ?? '').toLowerCase() == 'user';
    final content = message.content ?? '';
    final canCopy = content.trim().isNotEmpty;

    final Widget bubbleChild;
    if (isUser) {
      bubbleChild = DsText.bodyMedium(
        data: content,
        color: DsColors.onPrimary,
      );
    } else if (showTyping) {
      bubbleChild = const _TypingDots();
    } else {
      bubbleChild = GptMarkdown(content);
    }

    final Decoration decoration;
    if (isUser) {
      decoration = BoxDecoration(
        color: DsColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(DsBorderRadius.borderRadius16),
          bottomRight: Radius.circular(DsBorderRadius.borderRadius16),
          topLeft: Radius.circular(DsBorderRadius.borderRadius16),
          topRight: Radius.zero,
        ),
      );
    } else {
      decoration = BoxDecoration(
        gradient: LinearGradient(
          colors: [
            DsColors.backgroundSurface,
            DsColors.backgroundSubtle,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(DsBorderRadius.borderRadius16),
          bottomRight: Radius.circular(DsBorderRadius.borderRadius16),
          topLeft: Radius.zero,
          topRight: Radius.circular(DsBorderRadius.borderRadius16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      );
    }

    final messageBubble = Container(
      padding: EdgeInsets.symmetric(
        horizontal: DsSpacing.horizontalSpace16,
        vertical: DsSpacing.verticalSpace12,
      ),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.sizeOf(context).width * 0.7,
      ),
      decoration: decoration,
      child: bubbleChild,
    );

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: DsSpacing.verticalSpace8,
      ),
      child: Row(
        mainAxisAlignment:
        isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 16.r,
              backgroundColor: DsColors.backgroundSurface,
              child: Icon(
                Icons.bubble_chart_rounded,
                size: DsSizing.size20,
                color: DsColors.iconSecondary,
              ),
            ),
            DsSpacing.horizontalSpaceSizedBox8,
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              spacing: DsSpacing.verticalSpace4,
              children: [
                DsText.labelSmall(
                  data: isUser ? 'You' : 'AI',
                  color: DsColors.textSecondary,
                ),
                messageBubble,
                if (canCopy)
                  _MessageMetaBar(
                    isUser: isUser,
                    textToCopy: content,
                  ),
              ],
            ),
          ),
          if (isUser) ...[
            DsSpacing.horizontalSpaceSizedBox8,
            CircleAvatar(
              radius: 16.r,
              backgroundColor: DsColors.backgroundSurface,
              child: Icon(
                Icons.person_outline_rounded,
                size: DsSizing.size20,
                color: DsColors.iconSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MessageMetaBar extends StatelessWidget {
  const _MessageMetaBar({
    required this.isUser,
    required this.textToCopy,
  });

  final bool isUser;
  final String textToCopy;

  void _copy(BuildContext context) {
    Clipboard.setData(ClipboardData(text: textToCopy));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Message copied'),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.symmetric(
          horizontal: DsSpacing.horizontalSpace16,
          vertical: DsSpacing.verticalSpace12,
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(
      top: DsSpacing.verticalSpace4,
      left: isUser ? 0 : DsSpacing.horizontalSpace4,
      right: isUser ? DsSpacing.horizontalSpace4 : 0,
    ),
    child: Row(
      mainAxisAlignment:
      isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => _copy(context),
          borderRadius:
          BorderRadius.circular(DsBorderRadius.borderRadius8),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: DsSpacing.horizontalSpace4,
              vertical: DsSpacing.verticalSpace4,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.copy_rounded,
                  size: DsSizing.size14,
                  color: DsColors.textSecondary,
                ),
                DsSpacing.horizontalSpaceSizedBox4,
                const DsText.labelSmall(
                  data: 'Copy',
                  color: DsColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class _TypingDots extends StatefulWidget {
  const _TypingDots();

  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 36.w,
    height: 12.h,
    child: AnimatedBuilder(
      animation: _controller,
      builder: (_, __) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(3, (index) {
          final t = (_controller.value + index * 0.2) % 1.0;
          final scale = t < 0.5 ? t * 2 : (1 - t) * 2;
          final size = 4.0 + 2.0 * scale;

          return Container(
            width: size.w,
            height: size.w,
            decoration: BoxDecoration(
              color: DsColors.textSecondary.withOpacity(0.8),
              shape: BoxShape.circle,
            ),
          );
        }),
      ),
    ),
  );
}

class ChatInputBar extends StatefulWidget {
  const ChatInputBar({super.key});

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      BlocConsumer<ChatBloc, ChatState>(
        listener: _handleState,
        builder: (context, state) {
          final hasText =
              state.store.searchQuery?.input.trim().isNotEmpty ?? false;
          final isStreaming = state.store.isStreaming;

          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: DsSpacing.horizontalSpace16,
              vertical: DsSpacing.verticalSpace8,
            ),
            decoration:
            const BoxDecoration(color: DsColors.backgroundPrimary),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: DsSpacing.horizontalSpace8,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: DsColors.backgroundSurface,
                      borderRadius: BorderRadius.circular(
                        DsBorderRadius.borderRadius22,
                      ),
                      border: Border.all(color: DsColors.borderSubtle),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: DsSpacing.horizontalSpace2,
                      children: [
                        Expanded(
                          child: ChatTextFormField(
                            value: state.store.searchQuery,
                            controller: _controller,
                            hintText: 'Ask a question...',
                            onChanged: (queryString) =>
                                getBloc<ChatBloc>(context)
                                    .onQueryChanged(query: queryString),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.public_rounded,
                            color: state.store.webSearchEnabled
                                ? DsColors.primary
                                : DsColors.iconSecondary,
                          ),
                          onPressed: () =>
                              getBloc<ChatBloc>(context)
                                  .onWebSearchToggled(),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: DsColors.primary,
                    disabledBackgroundColor:
                    DsColors.primary.withAlpha(30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        DsBorderRadius.borderRadius12,
                      ),
                    ),
                  ),
                  iconSize: DsSizing.size24,
                  icon: Icon(
                    isStreaming
                        ? Icons.stop_rounded
                        : Icons.send_rounded,
                  ),
                  color: DsColors.onPrimary,
                  onPressed: isStreaming
                      ? () {
                    getBloc<ChatBloc>(context).stopGeneration();
                    FocusScope.of(context).unfocus();
                  }
                      : (hasText
                      ? () {
                    getBloc<ChatBloc>(context).sendMessage();
                    FocusScope.of(context).unfocus();
                  }
                      : null),
                ),
              ],
            ),
          );
        },
      );

  void _handleState(BuildContext context, ChatState state) => switch (state) {
    OnQueryUpdate(:final store) =>
    _controller.text = store.searchQuery?.input ?? '',
    _ => {},
  };
}
