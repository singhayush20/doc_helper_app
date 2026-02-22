import 'package:doc_helper_app/core/common/base_bloc/base_bloc.dart';
import 'package:doc_helper_app/core/common/base_widget/base_widget_utils.dart';
import 'package:doc_helper_app/core/common/constants/media_constants/image_keys.dart';
import 'package:doc_helper_app/core/common/utils/app_utils.dart';
import 'package:doc_helper_app/design/design.dart';
import 'package:doc_helper_app/di/injection.dart';
import 'package:doc_helper_app/feature/document_summarizer/domain/entities/doc_summary_enums.dart';
import 'package:doc_helper_app/feature/document_summarizer/presentation/bloc/summary_bloc/summary_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gpt_markdown/gpt_markdown.dart';

part 'summary_form.dart';

class SummaryPage extends StatelessWidget {
  const SummaryPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) {
          final args = GoRouterState.of(context).uri.queryParameters;
          return getIt<SummaryBloc>()..started(args: args);
        },
        child: BlocConsumer<SummaryBloc, SummaryState>(
          builder: (context, state) => const Scaffold(
            appBar: PrimaryAppBar(
              titleText: 'Document Summary',
            ),
            body: _SummaryForm(),
          ),
          listener: (context, state) => switch (state) {
            OnException(:final exception) =>
              handleException(exception, context),
            OnShowSummarySettingsDialog(:final store) =>
              _showSummarySettingsDialog(context, store),
            _ => null,
          },
        ),
      );
}
