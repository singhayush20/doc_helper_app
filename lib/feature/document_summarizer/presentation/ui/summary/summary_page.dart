import 'package:doc_helper_app/core/common/base_widget/base_widget_utils.dart';
import 'package:doc_helper_app/design/design.dart';
import 'package:doc_helper_app/di/injection.dart';
import 'package:doc_helper_app/feature/document_summarizer/presentation/bloc/doc_summarizer_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

part 'summary_form.dart';

class SummaryPage extends StatelessWidget {
  const SummaryPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) {
          final args = GoRouterState.of(context).uri.queryParameters;
          return getIt<DocSummarizerBloc>()..started(args: args);
        },
        child: BlocConsumer<DocSummarizerBloc, DocSummarizerState>(
          builder: (context, state) => Scaffold(
            appBar: PrimaryAppBar(
              titleText: 'Document Summary',
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_vert_rounded),
                ),
              ],
            ),
            body: const _SummaryForm(),
            bottomNavigationBar: const _SummaryActionBottomBar(),
          ),
          listener: (context, state) => switch (state) {
            OnException(:final exception) =>
              handleException(exception, context),
            _ => null,
          },
        ),
      );
}
