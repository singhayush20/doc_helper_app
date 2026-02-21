import 'dart:async';

import 'package:dio/dio.dart';
import 'package:doc_helper_app/core/common/base_bloc/base_bloc.dart';
import 'package:doc_helper_app/core/common/base_bloc/base_event.dart';
import 'package:doc_helper_app/core/common/base_bloc/base_state.dart';
import 'package:doc_helper_app/core/common/constants/app_constants.dart';
import 'package:doc_helper_app/core/common/utils/app_utils.dart';
import 'package:doc_helper_app/feature/document_summarizer/domain/entities/doc_summary_entity.dart';
import 'package:doc_helper_app/feature/document_summarizer/domain/entities/doc_summary_enums.dart';
import 'package:doc_helper_app/feature/document_summarizer/domain/interface/i_doc_summary_facade.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'doc_summarizer_bloc.freezed.dart';

part 'doc_summarizer_event.dart';

part 'doc_summarizer_state.dart';

@injectable
class DocSummarizerBloc
    extends BaseBloc<DocSummarizerEvent, DocSummarizerState> {
  DocSummarizerBloc(this._docSummaryFacade)
    : super(const DocSummarizerState.initial(store: DocSummarizerStateStore()));

  final IDocSummaryFacade _docSummaryFacade;
  static const int _maxFileSizeBytes = 5 * 1024 * 1024; // 5MB

  @override
  void handleEvents() {
    on<_Started>(_onStarted);
    on<_UploadDocument>(_onUploadDocument);
    on<_OnViewAllPressed>(_onViewAllPressed);
    on<_SummaryToneChanged>(_onSummaryToneChanged);
    on<_SummaryLengthChanged>(_onSummaryLengthChanged);
  }

  Future<void> _onStarted(
    _Started event,
    Emitter<DocSummarizerState> emit,
  ) async {
    invalidateLoader(emit, loading: true);
    final documentsResponseOrFailure = await _docSummaryFacade.getDocuments();

    documentsResponseOrFailure.fold(
      (exception) => handleException(emit, exception),
      (documents) => emit(
        DocSummarizerState.onDocumentDataFetch(
          store: state.store.copyWith(loading: false, documentsInfo: documents),
        ),
      ),
    );
  }

  Future<void> _onUploadDocument(
    _UploadDocument event,
    Emitter<DocSummarizerState> emit,
  ) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      final file = result.files.single;

      // Check file size
      if (file.size > _maxFileSizeBytes) {
        emit(
          DocSummarizerState.onValidationError(
            store: state.store.copyWith(
              validationErrorMessage: 'File size exceeds 5MB limit.',
              uploading: false,
            ),
          ),
        );
        return;
      }

      emit(
        DocSummarizerState.onUploadProgress(
          store: state.store.copyWith(
            uploading: true,
            uploadProgressMessage: 'Uploading ${file.name}...',
            validationErrorMessage: null,
          ),
        ),
      );

      final multipartFile = await MultipartFile.fromFile(
        file.path!,
        filename: file.name,
      );

      final response = await _docSummaryFacade.uploadDocument(multipartFile);

      response.fold((exception) => handleException(emit, exception), (
        documentDetails,
      ) {
        final currentDocuments = state.store.documentsInfo?.documents ?? [];
        final updatedDocumentsList = [documentDetails, ...currentDocuments];

        emit(
          DocSummarizerState.onUploadSuccess(
            store: state.store.copyWith(
              uploading: false,
              documentsInfo: state.store.documentsInfo?.copyWith(
                documents: updatedDocumentsList,
              ),
            ),
          ),
        );
      });
    }
  }

  void _onViewAllPressed(_, Emitter<DocSummarizerState> emit) {
    emit(DocSummarizerState.onViewAllPress(store: state.store));
  }

  void _onSummaryToneChanged(
    _SummaryToneChanged event,
    Emitter<DocSummarizerState> emit,
  ) {
    emit(
      DocSummarizerState.onPreferenceChanged(
        store: state.store.copyWith(selectedTone: event.tone),
      ),
    );
  }

  void _onSummaryLengthChanged(
    _SummaryLengthChanged event,
    Emitter<DocSummarizerState> emit,
  ) {
    emit(
      DocSummarizerState.onPreferenceChanged(
        store: state.store.copyWith(selectedLength: event.length),
      ),
    );
  }

  @override
  void started({Map<String, dynamic>? args}) {
    add(const DocSummarizerEvent.started());
  }

  void onViewAllPressed() {
    add(const DocSummarizerEvent.onViewAllPressed());
  }

  void onSummaryToneChanged(SummaryTone tone) {
    add(DocSummarizerEvent.summaryToneChanged(tone));
  }

  void onSummaryLengthChanged(SummaryLength length) {
    add(DocSummarizerEvent.summaryLengthChanged(length));
  }
}
