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

  CancelToken? _cancelToken;
  StreamSubscription<double>? _progressSubscription;

  @override
  void handleEvents() {
    on<_Started>(_onStarted);
    on<_UploadRequested>(_onUploadRequested);
    on<_FileSelected>(_onFileSelected);
    on<_UploadCancelled>(_onUploadCancelled);
    on<_UploadProgressUpdated>(_onUploadProgressUpdated);
    on<_OnUploadProgressError>(_onUploadProgressError);
    on<_UploadCompleted>(_onUploadCompleted);
  }

  Future<void> _onStarted(_Started event, Emitter<DocUploadState> emit) async {
    emit(DocUploadState.initial(store: state.store));
  }

  Future<void> _onUploadRequested(
    _UploadRequested event,
    Emitter<DocUploadState> emit,
  ) async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'txt'],
    );

    if (result == null || result.files.single.path == null) return;

    add(DocUploadEvent.fileSelected(result.files.single.path!));
  }

  Future<void> _startUpload(
    String filePath,
    Emitter<DocUploadState> emit,
  ) async {
    _cancelToken?.cancel();
    _cancelToken = CancelToken();

    final file = File(filePath);
    final fileName = file.uri.pathSegments.last;

    emit(
      DocUploadState.uploadInProgress(
        store: state.store.copyWith(
          isUploading: true,
          progress: 0,
          fileName: fileName,
        ),
      ),
    );

    final multipart = await MultipartFile.fromFile(filePath);

    _progressSubscription?.cancel();
    _progressSubscription = _userDocFacade
        .uploadDocument(file: multipart, cancelToken: _cancelToken!)
        .listen(
          (progress) => onUploadProgressUpdated(progress: progress),
          onError: (error) => onUploadProgressError(),
          onDone: () => onUploadCompleted(),
          cancelOnError: true,
        );
  }

  Future<void> _onFileSelected(
    _FileSelected event,
    Emitter<DocUploadState> emit,
  ) async {
    final file = File(event.filePath);
    if (!await file.exists()) {
      emit(
        DocUploadState.onUploadFailure(
          store: state.store.copyWith(
            isUploading: false,
            uploadError: 'File not found',
          ),
        ),
      );
      return;
    }

    await _startUpload(event.filePath, emit);
  }

  Future<void> _onUploadCancelled(
    _UploadCancelled event,
    Emitter<DocUploadState> emit,
  ) async {
    _cancelToken?.cancel('User cancelled upload');
    await _progressSubscription?.cancel();

    emit(
      DocUploadState.onUploadCancel(
        store: state.store.copyWith(isUploading: false, progress: 0),
      ),
    );
  }

  void _onUploadProgressUpdated(
    _UploadProgressUpdated event,
    Emitter<DocUploadState> emit,
  ) => emit(
    DocUploadState.uploadInProgress(
      store: state.store.copyWith(progress: event.progress, isUploading: true),
    ),
  );

  void _onUploadProgressError(
    _OnUploadProgressError event,
    Emitter<DocUploadState> emit,
  ) => emit(
    DocUploadState.onUploadProgressError(
      store: state.store.copyWith(
        isUploading: false,
        uploadError: 'Error occurred when uploading file',
      ),
    ),
  );

  Future<void> _onUploadCompleted(_, Emitter<DocUploadState> emit) async {
    emit(
      DocUploadState.onUploadSuccess(
        store: state.store.copyWith(isUploading: false, progress: 1),
      ),
    );
  }

  @override
  void started({Map<String, dynamic>? args}) {
    add(const DocUploadEvent.started());
  }

  @override
  Future<void> close() {
    _cancelToken?.cancel();
    _progressSubscription?.cancel();
    return super.close();
  }

  void uploadRequested() => add(const DocUploadEvent.uploadRequested());

  void cancelUpload() => add(const DocUploadEvent.uploadCancelled());

  void onUploadProgressUpdated({required double progress}) =>
      add(DocUploadEvent.uploadProgressUpdated(progress: progress));

  void onUploadProgressError() =>
      add(const DocUploadEvent.onUploadProgressError());

  void onUploadCompleted() => add(const DocUploadEvent.uploadCompleted());
}
