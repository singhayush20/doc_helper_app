import 'package:dio/dio.dart';
import 'package:doc_helper_app/core/common/base_bloc/base_bloc.dart';
import 'package:doc_helper_app/core/common/base_bloc/base_event.dart';
import 'package:doc_helper_app/core/common/base_bloc/base_state.dart';
import 'package:doc_helper_app/core/common/utils/app_utils.dart';
import 'package:doc_helper_app/feature/document_summarizer/domain/entities/doc_summary_entity.dart';
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
  }

  Future<void> _onStarted(
    _Started event,
    Emitter<DocSummarizerState> emit,
  ) async {}

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

      response.fold(
        (exception) => handleException(emit, exception),
        (uploadResponse) => emit(
          DocSummarizerState.onUploadSuccess(
            store: state.store.copyWith(
              uploading: false,
              uploadResponse: uploadResponse,
            ),
          ),
        ),
      );
    }
  }

  @override
  void started({Map<String, dynamic>? args}) {
    add(const DocSummarizerEvent.started());
  }
}
