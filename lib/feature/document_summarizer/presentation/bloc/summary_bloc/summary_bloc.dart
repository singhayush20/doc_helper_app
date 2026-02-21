import 'package:doc_helper_app/core/common/base_bloc/base_bloc.dart';
import 'package:doc_helper_app/core/common/base_bloc/base_event.dart';
import 'package:doc_helper_app/core/common/base_bloc/base_state.dart';
import 'package:doc_helper_app/core/common/constants/app_constants.dart';
import 'package:doc_helper_app/core/common/utils/app_utils.dart';
import 'package:doc_helper_app/feature/document_summarizer/domain/entities/doc_summary_entity.dart';
import 'package:doc_helper_app/feature/document_summarizer/domain/entities/doc_summary_enums.dart';
import 'package:doc_helper_app/feature/document_summarizer/domain/interface/i_doc_summary_facade.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'summary_event.dart';

part 'summary_state.dart';

part 'summary_bloc.freezed.dart';

@injectable
class SummaryBloc extends BaseBloc<SummaryEvent, SummaryState> {
  SummaryBloc(this._docSummaryFacade)
    : super(const SummaryState.initial(store: SummaryStateStore()));

  final IDocSummaryFacade _docSummaryFacade;

  @override
  void handleEvents() {
    on<_Started>(_onStarted);
  }

  Future<void> _onStarted(_Started event, Emitter<SummaryState> emit) async {
    invalidateLoader(emit, loading: true);

    final documentSummariesOrFailure = await _docSummaryFacade
        .getDocumentSummaries(event.documentId ?? -1);

    documentSummariesOrFailure.fold(
      (exception) => handleException(emit, exception),
      (docSummaries) => emit(
        SummaryState.onSummaryDataFetch(
          store: state.store.copyWith(
            loading: false,
            docSummaries: docSummaries,
          ),
        ),
      ),
    );
  }

  @override
  void started({Map<String, dynamic>? args}) {
    final documentId = args?[AppConstants.documentId] as int?;
    final tone = args?[AppConstants.summaryTone] as SummaryTone?;
    final length = args?[AppConstants.summaryLength] as SummaryLength?;

    add(SummaryEvent.started(documentId: documentId, tone: tone, length: length));
  }
}
