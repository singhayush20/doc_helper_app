import 'package:doc_helper_app/core/common/base_bloc/base_bloc.dart';
import 'package:doc_helper_app/core/common/constants/app_constants.dart';
import 'package:doc_helper_app/design/design.dart';
import 'package:doc_helper_app/di/injection.dart';
import 'package:doc_helper_app/feature/chat/domain/entities/chat_entities.dart';
import 'package:doc_helper_app/feature/chat/presentation/bloc/chat_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

part 'chat_form.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<ChatBloc>(
    create: (_) {
      final documentId = GoRouterState.of(
        context,
      ).uri.queryParameters[AppConstants.documentId];
      final documentName = GoRouterState.of(
        context,
      ).uri.queryParameters[AppConstants.documentName];
      return getIt<ChatBloc>()..started(
        args: {
          AppConstants.documentId: documentId,
          AppConstants.documentName: documentName,
        },
      );
    },
    child: BlocBuilder<ChatBloc,ChatState>(
      builder: (context, state) => Scaffold(
        appBar: PrimaryAppBar(titleText: state.store.documentName),
        body: const SafeArea(child: _ChatForm()),
      ),
    ),
  );
}
