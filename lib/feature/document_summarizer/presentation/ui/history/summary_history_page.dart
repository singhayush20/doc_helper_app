import 'package:doc_helper_app/core/common/base_bloc/base_bloc.dart';
import 'package:doc_helper_app/core/common/base_widget/base_widget_utils.dart';
import 'package:doc_helper_app/core/common/constants/app_constants.dart';
import 'package:doc_helper_app/core/common/constants/enums.dart';
import 'package:doc_helper_app/core/common/utils/app_utils.dart';
import 'package:doc_helper_app/core/common/utils/date_time_utils.dart';
import 'package:doc_helper_app/core/router/route_mapper.dart';
import 'package:doc_helper_app/core/value_objects/value_objects.dart';
import 'package:doc_helper_app/design/design.dart';
import 'package:doc_helper_app/design/molecules/list_tile/list_tile_subtitle.dart';
import 'package:doc_helper_app/design/molecules/list_tile/list_tile_title.dart';
import 'package:doc_helper_app/di/injection.dart';
import 'package:doc_helper_app/feature/document_summarizer/presentation/bloc/history_bloc/history_bloc.dart';
import 'package:doc_helper_app/feature/document_summarizer/presentation/ui/doc_file_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

part 'summary_history_form.dart';

class SummaryHistoryPage extends StatelessWidget {
  const SummaryHistoryPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<HistoryBloc>()..started(),
    child: BlocConsumer<HistoryBloc, HistoryState>(
      builder: (context, state) => const Scaffold(
        appBar: PrimaryAppBar(
          titleText: 'Summary History',
          backButtonRequired: true,
        ),
        body: SafeArea(child: _SummaryHistoryForm()),
      ),
      listener: _handleState,
    ),
  );

  void _handleState(BuildContext context, HistoryState state) =>
      switch (state) {
        OnDocumentPress(:final documentId) => context.pushNamed(
          Routes.summary,
          queryParameters: {AppConstants.documentId: documentId?.toString()},
        ),
        OnException(:final exception) => handleException(exception, context),
        _ => null,
      };
}
