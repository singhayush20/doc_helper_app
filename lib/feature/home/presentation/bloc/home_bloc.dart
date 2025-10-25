import 'package:doc_helper_app/core/common/base_bloc/base_bloc.dart';
import 'package:doc_helper_app/core/common/base_bloc/base_event.dart';
import 'package:doc_helper_app/core/common/base_bloc/base_state.dart';
import 'package:doc_helper_app/core/common/utils/app_utils.dart';
import 'package:doc_helper_app/feature/auth/domain/interfaces/i_auth_facade.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'home_bloc.freezed.dart';
part 'home_event.dart';
part 'home_state.dart';

@injectable
class HomeBloc extends BaseBloc<HomeEvent, HomeState> {
  HomeBloc(this._authFacade)
    : super(const HomeState.initial(store: HomeStateStore()));

  final IAuthFacade _authFacade;

  @override
  void handleEvents() {
    on<_Started>(_started);
    on<_OnLogoutPressed>(_onLogoutPressed);
  }

  void _started(_, Emitter<HomeState> emit) {}

  void _onLogoutPressed(_, Emitter<HomeState> emit) async {
    invalidateLoader(emit, loading: true);
    final signOutResponseOrFailure = await _authFacade.signOut();
    signOutResponseOrFailure.fold(
      (exception) => handleException(emit, exception),
      (_) => emit(
        HomeState.onLogoutSuccess(store: state.store.copyWith(loading: false)),
      ),
    );
  }

  @override
  void started({Map<String, dynamic>? args}) {
    add(const HomeEvent.started());
  }

  void onLogoutPressed() => add(const HomeEvent.onLogoutPressed());
}
