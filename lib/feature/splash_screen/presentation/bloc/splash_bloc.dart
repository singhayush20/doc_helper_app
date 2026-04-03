import 'package:dartz/dartz.dart';
import 'package:doc_helper_app/core/common/base_bloc/base_bloc.dart';
import 'package:doc_helper_app/core/common/base_bloc/base_event.dart';
import 'package:doc_helper_app/core/common/base_bloc/base_state.dart';
import 'package:doc_helper_app/core/common/utils/app_utils.dart';
import 'package:doc_helper_app/core/exception_handling/server_exception.dart';
import 'package:doc_helper_app/core/global_store/global_state_impl.dart';
import 'package:doc_helper_app/feature/auth/domain/interfaces/i_auth_facade.dart';
import 'package:doc_helper_app/feature/user/domain/entity/user.dart';
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

    Either<ServerException, AppUser?>? currentUserOrFailure;

    await Future.wait([
      (() async => currentUserOrFailure = await _authFacade.getCurrentUser())(),
      (() async => Future.delayed(const Duration(seconds: 4)))()
    ]);

    await currentUserOrFailure?.fold(
      (exception) async =>
          emit(state.getExceptionState(exception) as SplashState),
      (user) async {
        if (user != null) {
          final fetchResult = await globalState.fetchUserData();

          fetchResult.fold(
            (exception) => handleException(emit, exception),
            (_) => emit(
              SplashState.onCurrentUserFetch(
                store: state.store.copyWith(loading: false),
                user: user,
              ),
            ),
          );
        } else {
          emit(
            SplashState.onCurrentUserFetch(
              store: state.store.copyWith(loading: false),
              user: user,
            ),
          );
        }
      },
    );
  }

  @override
  void started({Map<String, dynamic>? args}) {
    add(SplashEvent.started(args));
  }
}
