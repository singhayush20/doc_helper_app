import 'dart:async';

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
    on<_OnSummaryIndexChanged>(_onSummaryIndexChanged);
    on<_OnSummarySettingsDialogRequested>(_onSummarySettingsDialogRequested);
  }

  Future<void> _onStarted(_Started event, Emitter<SummaryState> emit) async {
    final documentId = event.documentId;

    // considering that upload flow always requires tone and length
    if (event.tone != null && event.length != null) {
      invalidateLoader(emit, loading: true);
      final documentSummaryOrFailure = await _docSummaryFacade
          .summarizeDocument(
            documentId: documentId ?? -1,
            tone: event.tone ?? SummaryTone.casual,
            length: event.length ?? SummaryLength.short,
          );

      documentSummaryOrFailure.fold(
        (exception) => handleException(emit, exception),
        (summaryResponse) {
          final currentSummaries = state.store.docSummaries ?? [];
          final updatedSummariesList = [...currentSummaries, summaryResponse];

          emit(
            SummaryState.onSummaryDataFetch(
              store: state.store.copyWith(
                loading: false,
                documentId: documentId,
                currentSummaryIndex: updatedSummariesList.length - 1,
                docSummaries: updatedSummariesList,
              ),
            ),
          );
        },
      );
    } else {
      // else just show the summaries
      invalidateLoader(emit, loading: true);

      final documentSummariesOrFailure = await _docSummaryFacade
          .getDocumentSummaries(event.documentId ?? -1);

      documentSummariesOrFailure.fold(
        (exception) => handleException(emit, exception),
        (docSummaries) => emit(
          SummaryState.onSummaryDataFetch(
            store: state.store.copyWith(
              loading: false,
              documentId: documentId,
              currentSummaryIndex: 0,
              docSummaries: docSummaries.summaries,
            ),
          ),
        ),
      );
    }
  }

  void _onSummaryIndexChanged(
    _OnSummaryIndexChanged event,
    Emitter<SummaryState> emit,
  ) {
    emit(
      SummaryState.onSummaryIndexChanged(
        store: state.store.copyWith(currentSummaryIndex: event.index),
      ),
    );
  }

  void _onSummarySettingsDialogRequested(
    _OnSummarySettingsDialogRequested event,
    Emitter<SummaryState> emit,
  ) {
    invalidateLoader(emit, loading: true);
    emit(
      SummaryState.onShowSummarySettingsDialog(
        store: state.store.copyWith(loading: false),
      ),
    );
  }

  @override
  void started({Map<String, dynamic>? args}) {
    final documentId = args?[AppConstants.documentId] as String?;
    final tone = args?[AppConstants.summaryTone] as String?;
    final length = args?[AppConstants.summaryLength] as String?;

    add(
      SummaryEvent.started(
        documentId: int.tryParse(documentId ?? ''),
        tone: SummaryTone.values.asNameMap()[tone ?? ''],
        length: SummaryLength.values.asNameMap()[length ?? ''],
      ),
    );
  }

  void onSummaryIndexChanged({required int index}) {
    add(SummaryEvent.onSummaryIndexChanged(index: index));
  }

  void onSummarySettingsDialogRequested() {
    add(const SummaryEvent.onSummarySettingsDialogRequested());
  }

  void regenerateSummary({
    required int documentId,
    required SummaryTone tone,
    required SummaryLength length,
  }) {
    add(
      SummaryEvent.started(documentId: documentId, tone: tone, length: length),
    );
  }
}
