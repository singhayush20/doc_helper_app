import 'dart:async';

import 'package:doc_helper_app/common/base_bloc/base_bloc.dart';
import 'package:doc_helper_app/common/base_bloc/base_event.dart';
import 'package:doc_helper_app/common/base_bloc/base_state.dart';
import 'package:doc_helper_app/common/utils/app_utils.dart';
import 'package:doc_helper_app/core/value_objects/value_objects.dart';
import 'package:doc_helper_app/feature/auth/domain/interfaces/i_auth_facade.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'signin_bloc.freezed.dart';
part 'signin_event.dart';
part 'signin_state.dart';

@injectable
class SignInBloc extends BaseBloc<SignInEvent, SignInState> {
  SignInBloc(this._authFacade)
    : super(const SignInState.initial(store: SignInStateStore()));

  final IAuthFacade _authFacade;

  @override
  void handleEvents() {
    on<_Started>(_onStarted);
    on<_OnEmailChanged>(_onEmailChanged);
    on<_OnPasswordChanged>(_onPasswordChanged);
    on<_OnPasswordVisibilityChanged>(_onPasswordVisibilityChanged);
    on<_OnLoginPressed>(_onLoginPressed);
  }

  void _onStarted(_Started event, Emitter<SignInState> emit) {}

  void _onEmailChanged(_OnEmailChanged event, Emitter<SignInState> emit) {
    emit(
      SignInState.onEmailChange(
        store: state.store.copyWith(email: EmailAddress(event.emailString)),
      ),
    );
  }

  void _onPasswordChanged(_OnPasswordChanged event, Emitter<SignInState> emit) {
    emit(
      SignInState.onPasswordChange(
        store: state.store.copyWith(password: Password(event.passwordString)),
      ),
    );
  }

  void _onPasswordVisibilityChanged(
    _OnPasswordVisibilityChanged event,
    Emitter<SignInState> emit,
  ) {
    emit(
      SignInState.onPasswordVisibilityChange(
        store: state.store.copyWith(
          isPasswordVisible: !state.store.isPasswordVisible,
        ),
      ),
    );
  }

  Future<void> _onLoginPressed(_, Emitter<SignInState> emit) async {
    invalidateLoader(emit, loading: true);
    final loginResponseOrFailure = await _authFacade.signInWithEmailAndPassword(
      email: state.store.email,
      password: state.store.password,
    );

    loginResponseOrFailure.fold(
      (exception) => handleException(emit, exception),
      (loginResponse) => emit(
        SignInState.onLogin(store: state.store.copyWith(loading: false)),
      ),
    );
  }

  @override
  void started({Map<String, dynamic>? args}) {
    add(const SignInEvent.started());
  }

  void onEmailChanged({required String emailString}) {
    add(SignInEvent.onEmailChanged(emailString: emailString));
  }

  void onPasswordChanged({required String passwordString}) {
    add(SignInEvent.onPasswordChanged(passwordString: passwordString));
  }

  void onPasswordVisibilityChanged() {
    add(const SignInEvent.onPasswordVisibilityChanged());
  }

  void onLoginPressed() {
    add(const SignInEvent.onLoginPressed());
  }
}
