import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:doc_helper_app/core/common/base_bloc/base_bloc.dart';
import 'package:doc_helper_app/core/common/base_bloc/base_event.dart';
import 'package:doc_helper_app/core/common/base_bloc/base_state.dart';
import 'package:doc_helper_app/core/common/utils/app_utils.dart';
import 'package:doc_helper_app/feature/user_docs/domain/entities/user_doc_entity.dart';
import 'package:doc_helper_app/feature/user_docs/domain/interfaces/i_user_doc_facade.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'doc_upload_bloc.freezed.dart';
part 'doc_upload_event.dart';
part 'doc_upload_state.dart';

@injectable
class DocUploadBloc extends BaseBloc<DocUploadEvent, DocUploadState> {
  DocUploadBloc(this._userDocFacade)
      : super(
    const DocUploadState.initial(
      store: DocUploadStateStore(
        progress: 0,
        isUploading: false,
        fileName: '',
      ),
    ),
  );

  final IUserDocFacade _userDocFacade;

  @override
  void handleEvents() {
    on<_Started>(_onStarted);
    on<_UploadRequested>(_onUploadRequested);
    on<_FileSelected>(_onFileSelected);
  }

  @override
  void started({Map<String, dynamic>? args}) {
    add(const DocUploadEvent.started());
  }

  Future<void> _onStarted(
      _Started event,
      Emitter<DocUploadState> emit,
      ) async {
    emit(DocUploadState.initial(store: state.store));
  }

  Future<void> _onUploadRequested(
      _UploadRequested event,
      Emitter<DocUploadState> emit,
      ) async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
      withData: false,
    );

    if (result == null || result.files.isEmpty) {
      // user cancelled
      return;
    }

    final pickedFile = result.files.single;
    final path = pickedFile.path;

    if (path == null) {
      emit(
        DocUploadState.onException(
          store: state.store.copyWith(
            isUploading: false,
            errorMessage: 'Unable to access selected file',
          ),
          exception: Exception('File path is null'),
        ),
      );
      return;
    }

    add(DocUploadEvent.fileSelected(path));
  }

  Future<void> _onFileSelected(
      _FileSelected event,
      Emitter<DocUploadState> emit,
      ) async {
    final filePath = event.filePath;
    final file = File(filePath);

    if (!await file.exists()) {
      emit(
        DocUploadState.onException(
          store: state.store.copyWith(isUploading: false),
          exception: Exception('File not found'),
        ),
      );
      return;
    }

    final fileName = file.uri.pathSegments.last;

    emit(
      DocUploadState.uploadInProgress(
        store: state.store.copyWith(
          isUploading: true,
          progress: 0,
          fileName: fileName,
          errorMessage: null,
        ),
      ),
    );

    try {
      final multipart = await MultipartFile.fromFile(filePath);

      final responseOrFailure = await _userDocFacade.uploadDocument(multipart);

      responseOrFailure.fold(
            (exception) => handleException(emit, exception),
            (uploadResponse) {
          emit(
            DocUploadState.onUploadSuccess(
              store: state.store.copyWith(
                isUploading: false,
                progress: 1,
                uploadResponse: uploadResponse,
              ),
            ),
          );
        },
      );
    } catch (e) {
      emit(
        DocUploadState.onException(
          store: state.store.copyWith(
            isUploading: false,
            errorMessage: e.toString(),
          ),
          exception: Exception(e.toString()),
        ),
      );
    }
  }

  void uploadRequested() =>
      add(const DocUploadEvent.uploadRequested());
}
