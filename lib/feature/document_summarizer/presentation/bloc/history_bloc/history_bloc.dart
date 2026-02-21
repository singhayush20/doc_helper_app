import 'dart:async';

import 'package:doc_helper_app/core/common/base_bloc/base_bloc.dart';
import 'package:doc_helper_app/core/common/base_bloc/base_event.dart';
import 'package:doc_helper_app/core/common/base_bloc/base_state.dart';
import 'package:doc_helper_app/core/common/utils/app_utils.dart';
import 'package:doc_helper_app/feature/document_summarizer/domain/entities/doc_summary_entity.dart';
import 'package:doc_helper_app/feature/document_summarizer/domain/interface/i_doc_summary_facade.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'history_event.dart';
part 'history_state.dart';
part 'history_bloc.freezed.dart';

@injectable
class HistoryBloc extends BaseBloc<HistoryEvent, HistoryState> {
  HistoryBloc(this._docSummaryFacade)
      : super(const HistoryState.initial(store: HistoryStateStore()));

  final IDocSummaryFacade _docSummaryFacade;

  @override
  void handleEvents() {
    on<_Started>(_onStarted);
    on<_SearchQueryChanged>(_onSearchQueryChanged);
    on<_OnPageRefreshed>(_onPageRefreshed);
  }

  Future<void> _onStarted(_Started event, Emitter<HistoryState> emit) async {
    await _fetchHistory(emit);
  }

  void _onSearchQueryChanged(
    _SearchQueryChanged event,
    Emitter<HistoryState> emit,
  ) {
    final query = event.query.toLowerCase();
    final allDocuments = state.store.documentsInfo?.documents ?? [];

    final filtered = allDocuments.where((doc) {
      final fileName = doc.originalFilename?.toLowerCase() ?? '';
      return fileName.contains(query);
    }).toList();

    emit(
      HistoryState.onSearch(
        store: state.store.copyWith(
          searchQuery: event.query,
          filteredDocuments: filtered,
        ),
      ),
    );
  }

  Future<void> _onPageRefreshed(
    _OnPageRefreshed event,
    Emitter<HistoryState> emit,
  ) async {
    await _fetchHistory(emit);
  }

  Future<void> _fetchHistory(Emitter<HistoryState> emit) async {
    invalidateLoader(emit, loading: true);
    final historyOrFailure = await _docSummaryFacade.getDocuments();

    historyOrFailure.fold(
      (exception) => handleException(emit, exception),
      (history) => emit(
        HistoryState.onHistoryDataFetch(
          store: state.store.copyWith(
            loading: false,
            documentsInfo: history,
            filteredDocuments: history.documents,
            searchQuery: '',
          ),
        ),
      ),
    );
  }

  @override
  void started({Map<String, dynamic>? args}) {
    add(const HistoryEvent.started());
  }

  void searchQueryChanged(String query) {
    add(HistoryEvent.searchQueryChanged(query));
  }

  void onPageRefreshed() {
    add(const HistoryEvent.onPageRefreshed());
  }
}
