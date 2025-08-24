import 'package:doc_helper_app/common/base_bloc/base_bloc.dart';
import 'package:doc_helper_app/common/base_bloc/base_event.dart';
import 'package:doc_helper_app/common/base_bloc/base_state.dart';
import 'package:doc_helper_app/common/utils/app_utils.dart';
import 'package:doc_helper_app/feature/auth/domain/entities/user.dart';
import 'package:doc_helper_app/feature/auth/domain/interfaces/i_auth_facade.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'splash_bloc.freezed.dart';
part 'splash_event.dart';
part 'splash_state.dart';

@injectable
class SplashBloc extends BaseBloc<SplashEvent, SplashState> {
  SplashBloc(this._authFacade)
    : super(const SplashState.initial(store: SplashStateStore()));

  final IAuthFacade _authFacade;

  @override
  void handleEvents() {
    on<_Started>(_onStarted);
  }

  Future<void> _onStarted(_, Emitter<SplashState> emit) async {
    emit(state.getLoaderState(loading: true) as SplashState);
    final currentUserOrFailure = await _authFacade.getCurrentUser();

    await Future.delayed(const Duration(seconds: 4));

    currentUserOrFailure.fold(
      (exception) => emit(state.getExceptionState(exception) as SplashState),
      (user) {
        emit(
          SplashState.onCurrentUserFetch(
            store: state.store.copyWith(loading: false),
            user: user,
          ),
        );
      },
    );
  }

  @override
  void started({Map<String, dynamic>? args}) {
    add(SplashEvent.started(args));
  }
}
