part of 'email_verification_bloc.dart';

@freezed
sealed class EmailVerificationState extends BaseState
    with _$EmailVerificationState {
  const EmailVerificationState._();

  const factory EmailVerificationState.initial({
    required EmailVerificationStateStore store,
  }) = _Initial;

  const factory EmailVerificationState.onEmailOTPChange({
    required EmailVerificationStateStore store,
  }) = OnEmailOTPChange;

  const factory EmailVerificationState.onOTPVerificationSuccess({
    required EmailVerificationStateStore store,
  }) = OnOTPVerificationSuccess;

  const factory EmailVerificationState.onTimerUpdate({
    required EmailVerificationStateStore store,
  }) = OnTimerUpdate;

  const factory EmailVerificationState.onLogoutPress({
    required EmailVerificationStateStore store,
  }) = OnLogoutPress;

  const factory EmailVerificationState.invalidateLoader({
    required EmailVerificationStateStore store,
  }) = InvalidateLoader;

  const factory EmailVerificationState.onException({
    required EmailVerificationStateStore store,
    required Exception exception,
  }) = OnException;

  @override
  BaseState getExceptionState(Exception exception) =>
      EmailVerificationState.onException(
        store: store.copyWith(loading: false),
        exception: exception,
      );

  @override
  BaseState getLoaderState({required bool loading}) =>
      EmailVerificationState.invalidateLoader(
        store: store.copyWith(loading: loading),
      );
}

@liteFreezed
sealed class EmailVerificationStateStore with _$EmailVerificationStateStore {
  const factory EmailVerificationStateStore({
    EmailAddress? email,
    Otp? otp,
    int? timerValue,
    @Default(false) bool loading,
  }) = _EmailVerificationStateStore;
}
