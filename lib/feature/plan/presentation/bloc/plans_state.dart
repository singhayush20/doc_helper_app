part of 'plans_bloc.dart';

@freezed
sealed class PlansState extends BaseState with _$PlansState {
  const PlansState._();

  const factory PlansState.initial({required PlansStateStore store}) = _Initial;

  const factory PlansState.onPlansInfoFetch({required PlansStateStore store}) =
      _OnPlansInfoFetch;

  const factory PlansState.invalidateLoader({required PlansStateStore store}) =
      InvalidateLoader;

  const factory PlansState.onException({
    required PlansStateStore store,
    required Exception exception,
  }) = OnException;

  @override
  BaseState getExceptionState(Exception exception) => PlansState.onException(
    store: store.copyWith(loading: false),
    exception: exception,
  );

  @override
  BaseState getLoaderState({required bool loading}) =>
      PlansState.invalidateLoader(store: store.copyWith(loading: loading));
}

@liteFreezed
sealed class PlansStateStore with _$PlansStateStore {
  const factory PlansStateStore({
    SubscriptionResponse? subscriptionInfo,
    BillingProductsInfoList? billingProductsInfoList,
    SubscriptionResponse? subscriptionDetails,
    @Default(false) bool loading,
  }) = _PlansStateStore;
}
