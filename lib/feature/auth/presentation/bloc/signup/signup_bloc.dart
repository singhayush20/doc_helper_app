import 'package:doc_helper_app/common/base_bloc/base_bloc.dart';
import 'package:doc_helper_app/common/base_bloc/base_event.dart';
import 'package:doc_helper_app/common/base_bloc/base_state.dart';
import 'package:doc_helper_app/common/utils/app_utils.dart';
import 'package:doc_helper_app/core/value_objects/value_objects.dart';
import 'package:doc_helper_app/feature/auth/domain/interfaces/i_auth_facade.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'signup_bloc.freezed.dart';
part 'signup_event.dart';
part 'signup_state.dart';

class SignUpBloc extends BaseBloc<SignUpEvent, SignUpState> {
  SignUpBloc(this._authFacade)
    : super(const SignUpState.initial(store: SignUpStateStore()));

  final IAuthFacade _authFacade;

  @override
  void handleEvents() {
    on<_Started>(_onStarted);
    on<_OnEmailChanged>(_onEmailChanged);
    on<_OnPasswordChanged>(_onPasswordChanged);
    on<_OnConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<_OnNameChanged>(_onNameChanged);
    on<_OnCreateAccountClicked>(_onCreateAccountClicked);
    on<_OnPasswordVisibilityChanged>(_onPasswordVisibilityChanged);
  }

  void _onStarted(_, Emitter<SignUpState> emit) {
    emit(SignUpState.initial(store: state.store));
  }

  void _onEmailChanged(_OnEmailChanged event, Emitter<SignUpState> emit) {
    emit(
      SignUpState.onEmailChange(
        store: state.store.copyWith(email: EmailAddress(event.emailString)),
      ),
    );
  }

  void _onPasswordChanged(_OnPasswordChanged event, Emitter<SignUpState> emit) {
    emit(
      SignUpState.onPasswordChange(
        store: state.store.copyWith(password: Password(event.passwordString)),
      ),
    );
  }

  void _onConfirmPasswordChanged(
    _OnConfirmPasswordChanged event,
    Emitter<SignUpState> emit,
  ) {
    emit(
      SignUpState.onConfirmPasswordChange(
        store: state.store.copyWith(
          confirmPassword: Password(event.confirmPasswordString),
        ),
      ),
    );
  }

  void _onNameChanged(_OnNameChanged event, Emitter<SignUpState> emit) {
    emit(
      SignUpState.onNameChange(
        store: state.store.copyWith(name: Name(event.nameString)),
      ),
    );
  }

  Future<void> _onCreateAccountClicked(
    _OnCreateAccountClicked event,
    Emitter<SignUpState> emit,
  ) async {
    if ((state.store.email?.isValid() ?? false) &&
        (state.store.password?.isValid() ?? false) &&
        (state.store.password?.input == state.store.confirmPassword?.input)) {
      final createUserOrFailure = await _authFacade.signInWithEmailAndPassword(
        email: state.store.email,
        password: state.store.password,
      );

      createUserOrFailure.fold(
        (exception) => handleException(emit, exception),
        (_) {},
      );
    }
  }

  void _onPasswordVisibilityChanged(
    _OnPasswordVisibilityChanged event,
    Emitter<SignUpState> emit,
  ) {
    emit(
      SignUpState.onPasswordVisibilityChange(
        store: state.store.copyWith(
          isPasswordVisible: !state.store.isPasswordVisible,
        ),
      ),
    );
  }

  @override
  void started({Map<String, dynamic>? args}) {
    add(const SignUpEvent.started());
  }

  void onEmailChanged({required String emailString}) {
    add(SignUpEvent.onEmailChanged(emailString: emailString));
  }

  void onPasswordChanged({required String passwordString}) {
    add(SignUpEvent.onPasswordChanged(passwordString: passwordString));
  }

  void onConfirmPasswordChanged({required String passwordString}) {
    add(
      SignUpEvent.onConfirmPasswordChanged(
        confirmPasswordString: passwordString,
      ),
    );
  }

  void onNameChanged({required String nameString}) {
    add(SignUpEvent.onNameChanged(nameString: nameString));
  }

  void onCreateAccountClicked() {
    add(const SignUpEvent.onCreateAccountClicked());
  }

  void onPasswordVisibilityChanged() {
    add(const SignUpEvent.onPasswordVisibilityChanged());
  }
}
