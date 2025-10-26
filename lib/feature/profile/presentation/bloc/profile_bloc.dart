import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:doc_helper_app/core/common/base_bloc/base_bloc.dart';
import 'package:doc_helper_app/core/common/base_bloc/base_event.dart';
import 'package:doc_helper_app/core/common/base_bloc/base_state.dart';
import 'package:doc_helper_app/core/common/utils/app_utils.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'profile_bloc.freezed.dart';
part 'profile_event.dart';
part 'profile_state.dart';

@injectable
class ProfileBloc extends BaseBloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(const ProfileState.initial(store: ProfileStateStore()));

  @override
  void handleEvents() {
    on<_Started>(_onStarted);
  }

  Future<void> _onStarted(_, Emitter<ProfileState> emit) async {
  }

  @override
  void started({Map<String, dynamic>? args}) {
    add(const ProfileEvent.started());
  }

  void onLogoutPressed() {}
}
