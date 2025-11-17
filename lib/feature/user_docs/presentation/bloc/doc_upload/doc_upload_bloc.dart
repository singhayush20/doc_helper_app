import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:doc_helper_app/core/common/base_bloc/base_bloc.dart';
import 'package:doc_helper_app/core/common/base_bloc/base_event.dart';
import 'package:doc_helper_app/core/common/base_bloc/base_state.dart';
import 'package:doc_helper_app/core/common/utils/app_utils.dart';
import 'package:doc_helper_app/feature/user_docs/domain/entities/user_doc_entity.dart';
import 'package:doc_helper_app/feature/user_docs/domain/interfaces/i_user_doc_facade.dart';
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
  CancelToken? _cancelToken;

  @override
  void handleEvents() {
    on<_Started>(_onStarted);
    on<_FileSelected>(_onFileSelected);
    on<_UploadCancelled>(_onUploadCancelled);
  }

  Future<void> _onStarted(
      _Started event,
      Emitter<DocUploadState> emit,
      ) async {
    emit(DocUploadState.initial(store: state.store));
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
      DocUploadState.inProgress(
        store: state.store.copyWith(
          isUploading: true,
          progress: 0,
          fileName: fileName,
          errorMessage: null,
        ),
      ),
    );

    _cancelToken?.cancel('New upload started');
    _cancelToken = CancelToken();

    try {
      final multipart = await MultipartFile.fromFile(filePath);

      // NOTE: currently Facade upload is one-shot.
      // Progress = 0 at start, 1 at completion.
      final responseOrFailure =
      await _userDocFacade.uploadDocument(multipart); // existing facade

      responseOrFailure.fold(
            (exception) {
         handleException(emit, exception);
        },
            (uploadResponse) {
          emit(
            DocUploadState.success(
              store: state.store.copyWith(
                isUploading: false,
                progress: 1,
                uploadResponse: uploadResponse,
              ),
            ),
          );
        },
      );
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        emit(
          DocUploadState.cancelled(
            store: state.store.copyWith(
              isUploading: false,
              errorMessage: 'Upload cancelled',
            ),
          ),
        );
      } else {
        emit(
          DocUploadState.onException(
            store: state.store.copyWith(
              isUploading: false,
              errorMessage: e.message,
            ),
            exception: e,
          ),
        );
      }
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
    } finally {
      _cancelToken = null;
    }
  }

  Future<void> _onUploadCancelled(
      _UploadCancelled event,
      Emitter<DocUploadState> emit,
      ) async {
    _cancelToken?.cancel('User cancelled upload');
    emit(
      DocUploadState.cancelled(
        store: state.store.copyWith(
          isUploading: false,
          errorMessage: 'Upload cancelled',
        ),
      ),
    );
  }

  @override
  void started({Map<String, dynamic>? args}) {
    add(const DocUploadEvent.started());
  }

  void fileSelected(String filePath) =>
      add(DocUploadEvent.fileSelected(filePath));

  void cancelUpload() => add(const DocUploadEvent.uploadCancelled());
}
