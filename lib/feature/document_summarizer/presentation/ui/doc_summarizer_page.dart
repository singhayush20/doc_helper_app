import 'dart:ui';

import 'package:doc_helper_app/core/common/base_bloc/base_bloc.dart';
import 'package:doc_helper_app/core/common/base_widget/base_widget_utils.dart';
import 'package:doc_helper_app/core/common/constants/app_constants.dart';
import 'package:doc_helper_app/core/common/constants/enums.dart';
import 'package:doc_helper_app/core/common/utils/app_utils.dart';
import 'package:doc_helper_app/core/common/utils/date_time_utils.dart';
import 'package:doc_helper_app/core/router/route_mapper.dart';
import 'package:doc_helper_app/design/design.dart';
import 'package:doc_helper_app/design/molecules/list_tile/list_tile_subtitle.dart';
import 'package:doc_helper_app/design/molecules/list_tile/list_tile_title.dart';
import 'package:doc_helper_app/di/injection.dart';
import 'package:doc_helper_app/feature/document_summarizer/domain/entities/doc_summary_enums.dart';
import 'package:doc_helper_app/feature/document_summarizer/presentation/bloc/doc_summarizer_bloc.dart';
import 'package:doc_helper_app/feature/document_summarizer/presentation/ui/doc_file_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

part 'doc_summarizer_form.dart';

class DocSummarizerPage extends StatelessWidget {
  const DocSummarizerPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) => getIt<DocSummarizerBloc>()..started(),
    child: BlocConsumer<DocSummarizerBloc, DocSummarizerState>(
      builder: (context, state) => const Scaffold(
        appBar: PrimaryAppBar(
          titleText: 'Summarizer',
          backButtonRequired: true,
        ),
        body: SafeArea(child: _DocSummarizerForm()),
      ),
      listener: _handleState,
    ),
  );

  void _handleState(BuildContext context, DocSummarizerState state) =>
      switch (state) {
        OnUploadSuccess(:final store) => context.pushNamed(
          Routes.summary,
          queryParameters: {
            AppConstants.summaryLength: store.selectedLength.name,
            AppConstants.summaryTone: store.selectedTone.name,
            AppConstants.documentId:
                store.documentsInfo?.documents?[0].documentId?.toString(),
          },
        ),
        OnDocumentPress(:final documentId) => context.pushNamed(
          Routes.summary,
          queryParameters: {AppConstants.documentId: documentId?.toString()},
        ),
        OnViewAllPress _ => context.pushNamed(Routes.summaryHistory),
        OnException(:final exception) => handleException(exception, context),
        _ => null,
      };
}
