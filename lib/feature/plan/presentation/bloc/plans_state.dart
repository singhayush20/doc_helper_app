part of 'plans_bloc.dart';

@freezed
sealed class PlansState extends BaseState with _$PlansState {
  const PlansState._();

  const factory PlansState.initial({required PlansStateStore store}) = _Initial;

  const factory PlansState.onPlansInfoFetch({required PlansStateStore store}) =
      _OnPlansInfoFetch;

  const factory PlansState.onPlanCancel({required PlansStateStore store}) =
      OnPlanCancel;

  const factory PlansState.onBuyTap({
    required PlansStateStore store,
    required BillingProductInfo selectedProduct,
  }) = OnBuyTap;

  const factory PlansState.onDataRefreshed({required PlansStateStore store}) =
      OnDataRefreshed;

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
    BillingProductsInfoList? billingProductsInfoList,
    SubscriptionResponse? subscriptionDetails,
    @Default(false) bool refreshOnBackRequired,
    @Default(false) bool loading,
  }) = _PlansStateStore;
}
