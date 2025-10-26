part of 'home_bloc.dart';

@freezed
sealed class HomeState extends BaseState with _$HomeState {
  const HomeState._();

  const factory HomeState.initial({required HomeStateStore store}) =
      _HomeStateInitial;

  const factory HomeState.invalidateLoader({required HomeStateStore store}) =
      InvalidateLoader;

  const factory HomeState.onException({
    required HomeStateStore store,
    required Exception exception,
  }) = OnException;

  @override
  BaseState getExceptionState(Exception exception) => HomeState.onException(
    store: store.copyWith(loading: false),
    exception: exception,
  );

  @override
  BaseState getLoaderState({required bool loading}) =>
      HomeState.invalidateLoader(store: store.copyWith(loading: loading));
}

@liteFreezed
sealed class HomeStateStore with _$HomeStateStore {
  const factory HomeStateStore({@Default(false) bool loading}) =
      _HomeStateStore;
}
