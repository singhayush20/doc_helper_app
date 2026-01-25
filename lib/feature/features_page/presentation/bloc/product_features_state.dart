part of 'product_features_bloc.dart';

@freezed
sealed class ProductFeaturesState extends BaseState
    with _$ProductFeaturesState {
  const ProductFeaturesState._();

  const factory ProductFeaturesState.initial({
    required ProductFeaturesStateStore store,
  }) = _Initial;

  const factory ProductFeaturesState.invalidateLoader({
    required ProductFeaturesStateStore store,
  }) = InvalidateLoader;

  const factory ProductFeaturesState.onException({
    required ProductFeaturesStateStore store,
    required Exception exception,
  }) = OnException;

  @override
  BaseState getExceptionState(Exception exception) =>
      ProductFeaturesState.onException(
        store: store.copyWith(loading: false),
        exception: exception,
      );

  @override
  BaseState getLoaderState({required bool loading}) =>
      ProductFeaturesState.invalidateLoader(
        store: store.copyWith(loading: loading),
      );
}

@liteFreezed
sealed class ProductFeaturesStateStore with _$ProductFeaturesStateStore {
  const factory ProductFeaturesStateStore({@Default(false) bool loading}) =
      _HomeStateStore;
}
