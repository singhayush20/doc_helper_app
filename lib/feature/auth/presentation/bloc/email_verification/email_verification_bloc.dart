import 'dart:async';
import 'package:doc_helper_app/core/common/base_bloc/base_bloc.dart';
import 'package:doc_helper_app/core/common/base_bloc/base_event.dart';
import 'package:doc_helper_app/core/common/base_bloc/base_state.dart';
import 'package:doc_helper_app/core/common/utils/app_utils.dart';
import 'package:doc_helper_app/core/local_storage/i_local_storage_facade.dart';
import 'package:doc_helper_app/core/value_objects/value_objects.dart';
import 'package:doc_helper_app/feature/auth/domain/interfaces/i_auth_facade.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'email_verification_bloc.freezed.dart';

part 'email_verification_event.dart';

part 'email_verification_state.dart';

@injectable
class EmailVerificationBloc
    extends BaseBloc<EmailVerificationEvent, EmailVerificationState> {
  EmailVerificationBloc(this._authFacade, this._localStorageFacade)
    : super(
        const EmailVerificationState.initial(
          store: EmailVerificationStateStore(),
        ),
      );

  final IAuthFacade _authFacade;
  final ILocalStorageFacade _localStorageFacade;
  Timer? _timer;

  @override
  void handleEvents() {
    on<_Started>(_onStarted);
    on<_OnEmailOTPChanged>(_onEmailOtpChanged);
    on<_OnTimerStarted>(_onTimerStarted);
    on<_OnTimerTicked>(_onTimerTicked);
    on<_OnResendOTPPressed>(_onResendOTPPressed);
    on<_OnVerifyOTPPressed>(_onVerifyOTPPressed);
    on<_OnLogoutPressed>(_onLogoutPressed);
  }

  Future<void> _onStarted(
    _Started event,
    Emitter<EmailVerificationState> emit,
  ) async {
    final email = await _localStorageFacade.getUserEmail();

    emit(
      EmailVerificationState.initial(
        store: state.store.copyWith(email: EmailAddress(email ?? '')),
      ),
    );

    final otpResponseOrFailure = await _authFacade.sendEmailVerificationOtp(
      email: EmailAddress(email ?? ''),
    );

    otpResponseOrFailure.fold(
      (exception) => handleException(emit, exception),
      (_) => onTimerStarted(),
    );
  }

  void _onEmailOtpChanged(
    _OnEmailOTPChanged event,
    Emitter<EmailVerificationState> emit,
  ) {
    emit(
      EmailVerificationState.onEmailOTPChange(
        store: state.store.copyWith(otp: Otp(event.emailOTPString ?? '')),
      ),
    );
  }

  void _onTimerStarted(_, Emitter<EmailVerificationState> emit) {
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

  void _onTimerTicked(
    _OnTimerTicked event,
    Emitter<EmailVerificationState> emit,
  ) {
    emit(
      EmailVerificationState.onTimerUpdate(
        store: state.store.copyWith(timerValue: event.timerValue),
      ),
    );
  }

  Future<void> _onResendOTPPressed(
    _,
    Emitter<EmailVerificationState> emit,
  ) async {
    invalidateLoader(emit, loading: false);
    final sendOtpOrFailure = await _authFacade.sendEmailVerificationOtp(
      email: state.store.email,
    );

    sendOtpOrFailure.fold((exception) => handleException(emit, exception), (_) {
      onTimerStarted();
    });
  }

  Future<void> _onVerifyOTPPressed(
    _,
    Emitter<EmailVerificationState> emit,
  ) async {
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
      await _authFacade.forceRefreshToken();
      emit(
        EmailVerificationState.onOTPVerificationSuccess(
          store: state.store.copyWith(loading: false),
        ),
      );
    }
  }

  Future<void> _onLogoutPressed(_, Emitter<EmailVerificationState> emit) async {
    invalidateLoader(emit, loading: true);
    final signOutResponseOrFailure = await _authFacade.signOut();
    signOutResponseOrFailure.fold(
      (exception) => handleException(emit, exception),
      (_) => emit(
        EmailVerificationState.onLogoutPress(
          store: state.store.copyWith(loading: false),
        ),
      ),
    );
  }

  @override
  void started({Map<String, dynamic>? args}) {
    add(const EmailVerificationEvent.started());
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  void onOtpChanged({required String? otpString}) =>
      add(EmailVerificationEvent.onEmailOTPChanged(emailOTPString: otpString));

  void onResendOTPPressed() =>
      add(const EmailVerificationEvent.onResendOTPPressed());

  void onVerifyOTPPressed() =>
      add(const EmailVerificationEvent.onVerifyOTPPressed());

  void onTimerStarted() => add(const EmailVerificationEvent.onTimerStarted());

  void onTimerTicked({required int timerValue}) =>
      add(EmailVerificationEvent.onTimerTicked(timerValue: timerValue));

  void onLogoutPressed() => add(const EmailVerificationEvent.onLogoutPressed());
}
