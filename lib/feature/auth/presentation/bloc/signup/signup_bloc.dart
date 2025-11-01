import 'dart:async';

import 'package:doc_helper_app/core/common/base_bloc/base_bloc.dart';
import 'package:doc_helper_app/core/common/base_bloc/base_event.dart';
import 'package:doc_helper_app/core/common/base_bloc/base_state.dart';
import 'package:doc_helper_app/core/common/utils/app_utils.dart';
import 'package:doc_helper_app/core/value_objects/value_objects.dart';
import 'package:doc_helper_app/feature/auth/domain/interfaces/i_auth_facade.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'signup_bloc.freezed.dart';
part 'signup_event.dart';
part 'signup_state.dart';

@injectable
class SignUpBloc extends BaseBloc<SignUpEvent, SignUpState> {
  SignUpBloc(this._authFacade)
    : super(const SignUpState.initial(store: SignUpStateStore()));

  final IAuthFacade _authFacade;
  Timer? _timer;

  @override
  void handleEvents() {
    on<_Started>(_onStarted);
    on<_OnEmailChanged>(_onEmailChanged);
    on<_OnPasswordChanged>(_onPasswordChanged);
    on<_OnConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<_OnLastNameChanged>(_onLastNameChanged);
    on<_OnFirstNameChanged>(_onFirstNameChanged);
    on<_OnCreateAccountClicked>(_onCreateAccountClicked);
    on<_OnPasswordVisibilityChanged>(_onPasswordVisibilityChanged);
    on<_OnSignInPressed>(_onSignInPressed);
    on<_OnEmailOTPChanged>(_onEmailOtpChanged);
    on<_OnTimerStarted>(_onTimerStarted);
    on<_OnTimerTicked>(_onTimerTicked);
    on<_OnResendOTPPressed>(_onResendOTPPressed);
    on<_OnVerifyOTPPressed>(_onVerifyOTPPressed);
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

  void _onFirstNameChanged(
    _OnFirstNameChanged event,
    Emitter<SignUpState> emit,
  ) {
    emit(
      SignUpState.onFirstNameChange(
        store: state.store.copyWith(firstName: Name(event.firstNameString)),
      ),
    );
  }

  Future<void> _onCreateAccountClicked(
    _OnCreateAccountClicked event,
    Emitter<SignUpState> emit,
  ) async {
    invalidateLoader(emit, loading: true);
    final signUpUserOrError = await _authFacade.signUpUser(
      email: state.store.email,
      password: state.store.password,
      firstName: state.store.firstName,
      lastName: state.store.lastName,
    );

    signUpUserOrError.fold(
      (exception) => handleException(emit, exception),
      (_) {},
    );

    if (signUpUserOrError.isRight()) {
      await _authFacade.sendEmailVerificationOtp(email: state.store.email);

      emit(
        SignUpState.onAccountCreate(
          store: state.store.copyWith(loading: false, userDetailsEntered: true),
        ),
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

  void _onLastNameChanged(_OnLastNameChanged event, Emitter<SignUpState> emit) {
    emit(
      SignUpState.onLastNameChange(
        store: state.store.copyWith(lastName: Name(event.lastNameString)),
      ),
    );
  }

  Future<void> _onSignInPressed(_, Emitter<SignUpState> emit) async {
    emit(SignUpState.onSignInPress(store: state.store));
  }

  void _onEmailOtpChanged(_OnEmailOTPChanged event, Emitter<SignUpState> emit) {
    emit(
      SignUpState.onEmailOTPChange(
        store: state.store.copyWith(otp: Otp(event.emailOTPString ?? '')),
      ),
    );
  }

  void _onTimerStarted(_, Emitter<SignUpState> emit) {
    _timer?.cancel();
    const countDownFrom = 60;

    onTimerTicked(timerValue: countDownFrom);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final newTime = countDownFrom - timer.tick;
      if (newTime >= 0) {
        onTimerTicked(timerValue: newTime);
      } else {
        timer.cancel();
      }
    });
  }

  void _onTimerTicked(_OnTimerTicked event, Emitter<SignUpState> emit) {
    emit(
      SignUpState.onTimerUpdate(
        store: state.store.copyWith(timerValue: event.timerValue),
      ),
    );
  }

  Future<void> _onResendOTPPressed(_, Emitter<SignUpState> emit) async {
    invalidateLoader(emit, loading: false);
    final sendOtpOrFailure = await _authFacade.sendEmailVerificationOtp(
      email: state.store.email,
    );

    sendOtpOrFailure.fold((exception) => handleException(emit, exception), (_) {
      onTimerStarted();
    });
  }

  Future<void> _onVerifyOTPPressed(_, Emitter<SignUpState> emit) async {
    invalidateLoader(emit, loading: true);
    final otpVerificationOrFailure = await _authFacade
        .verifyEmailVerificationOtp(
          email: state.store.email,
          otp: state.store.otp,
        );

    otpVerificationOrFailure.fold(
      (exception) => handleException(emit, exception),
      (_) {},
    );

    if (otpVerificationOrFailure.isRight()) {
      if ((state.store.email?.isValid() ?? false) &&
          (state.store.password?.isValid() ?? false) &&
          (state.store.password?.input == state.store.confirmPassword?.input)) {
        final createUserOrFailure = await _authFacade
            .signInWithEmailAndPassword(
              email: state.store.email,
              password: state.store.password,
            );

        createUserOrFailure.fold(
          (exception) {
            handleException(emit, exception);
            return;
          },
          (_) => emit(
            SignUpState.onOTPVerificationSuccess(
              store: state.store.copyWith(loading: false),
            ),
          ),
        );
      }
    }
  }

  @override
  void started({Map<String, dynamic>? args}) {
    add(const SignUpEvent.started());
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
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

  void onFirstNameChanged({required String firstNameString}) {
    add(SignUpEvent.onFirstNameChanged(firstNameString: firstNameString));
  }

  void onLastNameChanged({required String lastNameString}) {
    add(SignUpEvent.onLastNameChanged(lastNameString: lastNameString));
  }

  void onCreateAccountClicked() {
    add(const SignUpEvent.onCreateAccountClicked());
  }

  void onPasswordVisibilityChanged() {
    add(const SignUpEvent.onPasswordVisibilityChanged());
  }

  void onSignInPressed() => add(const SignUpEvent.onSignInPressed());

  void onOtpChanged({required String? otpString}) =>
      add(SignUpEvent.onEmailOTPChanged(emailOTPString: otpString));

  void onResendOTPPressed() => add(const SignUpEvent.onResendOTPPressed());

  void onVerifyOTPPressed() => add(const SignUpEvent.onVerifyOTPPressed());

  void onTimerStarted() => add(const SignUpEvent.onTimerStarted());

  void onTimerTicked({required int timerValue}) =>
      add(SignUpEvent.onTimerTicked(timerValue: timerValue));
}
