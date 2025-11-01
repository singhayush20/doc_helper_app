import 'dart:async';

import 'package:doc_helper_app/core/common/base_bloc/base_bloc.dart';
import 'package:doc_helper_app/core/common/base_bloc/base_event.dart';
import 'package:doc_helper_app/core/common/base_bloc/base_state.dart';
import 'package:doc_helper_app/core/common/utils/app_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'user_doc_bloc.freezed.dart';
part 'user_doc_event.dart';
part 'user_doc_state.dart';

@injectable
class UserDocBloc extends BaseBloc<UserDocEvent, UserDocState> {
  UserDocBloc() : super(const UserDocState.initial(store: UserDocStateStore()));

  @override
  void handleEvents() {
    on<_Started>(_onStarted);
  }

  Future<void> _onStarted(_Started event, Emitter<UserDocState> emit) async {
    emit(UserDocState.initial(store: state.store));
  }

  @override
  void started({Map<String, dynamic>? args}) {
    add(const UserDocEvent.started());
  }
}
