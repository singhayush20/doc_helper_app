part of 'signup_bloc.dart';

@freezed
sealed class SignUpState extends BaseState with _$SignUpState {
  const SignUpState._();

  const factory SignUpState.initial({required SignUpStateStore store}) =
      Initial;

  const factory SignUpState.invalidateLoader({
    required SignUpStateStore store,
  }) = InvalidateLoader;

  const factory SignUpState.onException({
    required SignUpStateStore store,
    required Exception exception,
  }) = OnException;

  @override
  BaseState getExceptionState(Exception exception) => SignUpState.onException(
    store: store.copyWith(loading: false),
    exception: exception,
  );

  @override
  BaseState getLoaderState({required bool loading}) =>
      SignUpState.invalidateLoader(store: store.copyWith(loading: loading));
}

@liteFreezed
sealed class SignUpStateStore with _$SignUpStateStore {
  const factory SignUpStateStore({@Default(false) bool loading}) =
      _SignUpStateStore;
}
