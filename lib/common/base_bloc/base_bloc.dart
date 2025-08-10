import 'package:doc_helper_app/common/base_bloc/base_event.dart';
import 'package:doc_helper_app/common/base_bloc/base_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseBloc<Event extends BaseEvent, State extends BaseState>
    extends Bloc<Event, State> {
  BaseBloc(super.initialState) {
    if (!isClosed) {
      handleEvents();
    }
  }

  void handleEvents();

  void started({Map<String, dynamic>? args});

  void invalidateLoader(Emitter<State> emit, {bool loading = false}) {
    emit(state.getLoaderState(loading: loading) as State);
  }

  void handleException(Emitter<State> emit, Exception exception) {
    emit(state.getExceptionState(exception) as State);
  }

  B getBloc<B extends BaseBloc>(BuildContext context) =>
      BlocProvider.of<B>(context);

  S getState<B extends BaseBloc, S>(BuildContext context) =>
      getBloc<B>(context).state as S;
}
