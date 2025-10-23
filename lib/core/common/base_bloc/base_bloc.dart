import 'package:doc_helper_app/core/common/base_bloc/base_event.dart';
import 'package:doc_helper_app/core/common/base_bloc/base_state.dart';
import 'package:doc_helper_app/core/exception_handling/server_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseBloc<Event extends BaseEvent, S extends BaseState>
    extends Bloc<Event, S> {
  BaseBloc(super.initialState) {
    if (!isClosed) {
      handleEvents();
    }
  }

  void handleEvents();

  void started({Map<String, dynamic>? args});

  void invalidateLoader(Emitter<S> emit, {bool loading = false}) {
    emit(state.getLoaderState(loading: loading) as S);
  }

  void handleException(Emitter<S> emit, ServerException exception) {
    emit(state.getExceptionState(exception) as S);
  }
}

B getBloc<B extends BaseBloc>(BuildContext context) =>
    BlocProvider.of<B>(context);

S getState<B extends BaseBloc, S>(BuildContext context) =>
    getBloc<B>(context).state as S;
