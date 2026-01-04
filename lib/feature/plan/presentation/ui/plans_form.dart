part of 'plans_page.dart';

class _PlansForm extends StatelessWidget {
  const _PlansForm();

  @override
  Widget build(BuildContext context) => BlocBuilder<PlansBloc, PlansState>(
    builder: (context, state) => DsShimmer(
      enabled: state.store.loading,
      child: Visibility(
        visible:
            !state.store.loading && state.store.billingProductsInfoList != null,
        replacement: const _PlanCardShimmer(),
        child: ListView.separated(
          shrinkWrap: true,
          itemBuilder: (_, index) {
            final billingProduct =
                state.store.billingProductsInfoList?.products?[index];
            final isActive =
                billingProduct?.code ==
                state.store.subscriptionDetails?.planCode;
            return _PlanCard(isActive: isActive, product: billingProduct);
          },
          separatorBuilder: (_, index) =>
              index ==
                  (state.store.billingProductsInfoList?.products?.length ?? 0) -
                      1
              ? const SizedBox()
              : DsSpacing.verticalSpaceSizedBox16,
          itemCount: state.store.billingProductsInfoList?.products?.length ?? 0,
        ),
      ),
    ),
  );
}

class _PlanCardShimmer extends StatelessWidget {
  const _PlanCardShimmer();

  @override
  Widget build(BuildContext context) => ListView.separated(
    shrinkWrap: true,
    primary: false,
    separatorBuilder: (_, index) =>
        index != 4 ? DsSpacing.verticalSpaceSizedBox16 : const SizedBox(),
    itemCount: 5,
    itemBuilder: (_, index) => DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius16),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: DsSpacing.radialSpace8,
          vertical: DsSpacing.radialSpace12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 16.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: DsColors.backgroundDisabled,
                borderRadius: BorderRadius.circular(
                  DsBorderRadius.borderRadius4,
                ),
              ),
            ),
            DsSpacing.verticalSpaceSizedBox16,
            ListView.separated(
              shrinkWrap: true,
              primary: false,
              itemCount: 4,
              separatorBuilder: (_, index) => (index == 4)
                  ? const SizedBox()
                  : DsSpacing.verticalSpaceSizedBox4,
              itemBuilder: (_, index) => Container(
                height: 16.h,
                decoration: BoxDecoration(
                  color: DsColors.backgroundDisabled,
                  borderRadius: BorderRadius.circular(
                    DsBorderRadius.borderRadius4,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({this.isActive = false, this.product});

  final bool isActive;
  final BillingProductInfo? product;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: isActive
          ? DsColors.backgroundEnabled.withAlpha(70)
          : DsColors.backgroundSurface,
      borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius16),
      boxShadow: [
        BoxShadow(
          color: DsColors.primary.withAlpha(5),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: Padding(
      padding: EdgeInsets.all(DsSpacing.radialSpace24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DsText.titleLarge(data: product?.displayName ?? ''),
              _ProductBadge(isActive: isActive),
            ],
          ),
          DsSpacing.verticalSpaceSizedBox16,
          const Divider(color: DsColors.dividerColor),
          DsSpacing.verticalSpaceSizedBox24,
          ListView.separated(
            shrinkWrap: true,
            primary: false,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (_, index) =>
                _FeatureItem(data: product?.features?[index] ?? ''),
            separatorBuilder: (_, index) =>
                index == (product?.features?.length ?? 0) - 1
                ? const SizedBox()
                : DsSpacing.verticalSpaceSizedBox8,
            itemCount: product?.features?.length ?? 0,
          ),
          if (!isActive) ...[
            DsSpacing.verticalSpaceSizedBox32,
            DsButton.primary(data: 'Buy Subscription', onTap: () {}),
          ],
          DsSpacing.verticalSpaceSizedBox16,
        ],
      ),
    ),
  );
}

class _ProductBadge extends StatelessWidget {
  const _ProductBadge({this.isActive = false});

  final bool isActive;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      gradient: isActive
          ? const LinearGradient(
              colors: [DsColors.secondaryDark, DsColors.secondaryLight],
            )
          : const LinearGradient(
              colors: [DsColors.primary, DsColors.primaryDark],
            ),
      borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius20),
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: DsSpacing.radialSpace12,
        vertical: DsSpacing.radialSpace4,
      ),
      child: DsText.labelMedium(
        data: isActive ? 'Active' : 'Best Value',
        color: DsColors.textOnDark,
      ),
    ),
  );
}

class _FeatureItem extends StatelessWidget {
  const _FeatureItem({required this.data});

  final String data;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        decoration: BoxDecoration(
          color: DsColors.success.withAlpha(10),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.check,
          size: DsSizing.size16,
          color: DsColors.success,
        ),
      ),
      DsSpacing.horizontalSpaceSizedBox12,
      Expanded(
        child: DsText.bodyMedium(data: data, color: DsColors.textPrimary),
      ),
    ],
  );
}
