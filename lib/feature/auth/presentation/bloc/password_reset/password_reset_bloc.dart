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

part 'password_reset_bloc.freezed.dart';

part 'password_reset_event.dart';

part 'password_reset_state.dart';

@injectable
class PasswordResetBloc
    extends BaseBloc<PasswordResetEvent, PasswordResetState> {
  PasswordResetBloc(this._authFacade)
    : super(const PasswordResetState.initial(store: PasswordResetStateStore()));

  final IAuthFacade _authFacade;
  Timer? _timer;

  @override
  void handleEvents() {
    on<_Started>(_onStarted);
    on<_OnEmailChanged>(_onEmailChanged);
    on<_OnSendOTPPressed>(_onSendOTPPressed);
    on<_OnOTPChanged>(_onOTPChanged);
    on<_OnPasswordChanged>(_onPasswordChanged);
    on<_OnConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<_OnPasswordVisibilityChanged>(_onPasswordVisibilityChanged);
    on<_OnSavePasswordPressed>(_onSavePasswordPressed);
    on<_OnChangeEmailPressed>(_onChangeEmailPressed);
    on<_OnTimerStarted>(_onTimerStarted);
    on<_OnTimerTicked>(_onTimerTicked);
  }

  void _onStarted(_Started event, Emitter<PasswordResetState> emit) {
    emit(PasswordResetState.initial(store: state.store));
  }

  void _onEmailChanged(
    _OnEmailChanged event,
    Emitter<PasswordResetState> emit,
  ) {
    emit(
      PasswordResetState.onEmailChange(
        store: state.store.copyWith(email: EmailAddress(event.emailString)),
      ),
    );
  }

  void _onPasswordChanged(
    _OnPasswordChanged event,
    Emitter<PasswordResetState> emit,
  ) {
    emit(
      PasswordResetState.onPasswordChange(
        store: state.store.copyWith(password: Password(event.passwordString)),
      ),
    );
  }

  void _onConfirmPasswordChanged(
    _OnConfirmPasswordChanged event,
    Emitter<PasswordResetState> emit,
  ) {
    emit(
      PasswordResetState.onConfirmPasswordChange(
        store: state.store.copyWith(
          confirmPassword: Password(event.passwordString),
        ),
      ),
    );
  }

  void _onPasswordVisibilityChanged(
    _OnPasswordVisibilityChanged event,
    Emitter<PasswordResetState> emit,
  ) {
    emit(
      PasswordResetState.onPasswordVisibilityChange(
        store: state.store.copyWith(
          isPasswordVisible: !state.store.isPasswordVisible,
        ),
      ),
    );
  }

  Future<void> _onSendOTPPressed(_, Emitter<PasswordResetState> emit) async {
    invalidateLoader(emit, loading: true);
    final sendOtpResultOrFailure = await _authFacade.sendPasswordResetOtp(
      email: state.store.email,
    );

    sendOtpResultOrFailure.fold(
      (exception) => handleException(emit, exception),
      (_) {
        emit(
          PasswordResetState.onOtpSent(
            store: state.store.copyWith(loading: false, otpSent: true),
          ),
        );

        onTimerStarted();
      },
    );
  }

  void _onOTPChanged(_OnOTPChanged event, Emitter<PasswordResetState> emit) =>
      emit(
        PasswordResetState.onOTPChange(
          store: state.store.copyWith(otp: Otp(event.otpString ?? '')),
        ),
      );

  Future<void> _onSavePasswordPressed(
    _OnSavePasswordPressed event,
    Emitter<PasswordResetState> emit,
  ) async {
    invalidateLoader(emit, loading: true);
    final resetPasswordResultOrFailure = await _authFacade.resetPassword(
      email: state.store.email,
      otp: state.store.otp,
      password: state.store.password,
    );
    resetPasswordResultOrFailure.fold(
      (exception) => handleException(emit, exception),
      (_) => emit(
        PasswordResetState.onPasswordSaved(
          store: state.store.copyWith(loading: false),
        ),
      ),
    );
  }

  void _onChangeEmailPressed(_, Emitter<PasswordResetState> emit) {
    emit(
      PasswordResetState.onChangeEmailPress(
        store: state.store.copyWith(
          otpSent: false,
          otp: null,
          password: null,
          confirmPassword: null,
        ),
      ),
    );
  }

  void _onTimerStarted(_, Emitter<PasswordResetState> emit) {
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

  void _onTimerTicked(_OnTimerTicked event, Emitter<PasswordResetState> emit) {
    emit(
      state.copyWith(store: state.store.copyWith(timerValue: event.timerValue)),
    );
  }

  @override
  void started({Map<String, dynamic>? args}) {
    add(const PasswordResetEvent.started());
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  void onEmailChanged({required String emailString}) =>
      add(PasswordResetEvent.onEmailChanged(emailString: emailString));

  void onPasswordChanged({required String passwordString}) =>
      add(PasswordResetEvent.onPasswordChanged(passwordString: passwordString));

  void onConfirmPasswordChanged({required String passwordString}) => add(
    PasswordResetEvent.onConfirmPasswordChanged(passwordString: passwordString),
  );

  void onPasswordVisibilityChanged() =>
      add(const PasswordResetEvent.onPasswordVisibilityChanged());

  void onSendOtpPressed() => add(const PasswordResetEvent.onSendOTPPressed());

  void onOTPChanged({required String? otpString}) =>
      add(PasswordResetEvent.onOTPChanged(otpString: otpString));

  void onSavePasswordPressed() =>
      add(const PasswordResetEvent.onSavePasswordPressed());

  void onChangeEmailPressed() =>
      add(const PasswordResetEvent.onChangeEmailPressed());

  void onTimerStarted() {
    add(const PasswordResetEvent.onTimerStarted());
  }

  void onTimerTicked({required int timerValue}) {
    add(PasswordResetEvent.onTimerTicked(timerValue: timerValue));
  }
}
