part of 'payment_page.dart';

class _PaymentForm extends StatelessWidget {
  const _PaymentForm();

  @override
  Widget build(BuildContext context) => BlocBuilder<PaymentBloc, PaymentState>(
    builder: (context, state) => Padding(
      padding: EdgeInsets.symmetric(
        horizontal: DsSpacing.radialSpace16,
        vertical: DsSpacing.radialSpace24,
      ),
      child: DsShimmer(
        enabled: state.store.pricesResponse == null,
        child: (state.store.pricesResponse == null)
            ? const _PaymentCardShimmer()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        spacing: DsSpacing.verticalSpace12,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const _PlanSection(),
                          const _PricesSection(),
                        ],
                      ),
                    ),
                  ),
                  DsSpacing.verticalSpaceSizedBox24,
                  DsButton.primary(
                    data: 'Proceed to Payment',
                    onTap: (state.store.selectedPriceCode == null)
                        ? null
                        : () => getBloc<PaymentBloc>(context).onCheckoutStarted(
                            priceCode: state.store.selectedPriceCode,
                          ),
                  ),
                  DsSpacing.verticalSpaceSizedBox8,
                ],
              ),
      ),
    ),
  );
}

class _PlanSection extends StatelessWidget {
  const _PlanSection();

  @override
  Widget build(BuildContext context) => BlocBuilder<PaymentBloc, PaymentState>(
    builder: (context, state) {
      final product = state.store.billingProductInfo;
      return DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius16),
          border: Border.all(color: DsColors.borderDefault),
        ),
        child: Padding(
          padding: EdgeInsets.all(DsSpacing.radialSpace20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: DsSpacing.verticalSpace8,
            children: [
              DsText.headlineMedium(
                data: product?.displayName ?? '',
                color: DsColors.textPrimary,
              ),
              if (product?.monthlyTokenLimit != null) ...[
                DsText.labelMedium(
                  data:
                      '''${formatNumberWithSymbol(product?.monthlyTokenLimit?.toDouble())} tokens per month''',
                  color: DsColors.textSecondary,
                ),
              ],
              if ((product?.features?.isNotEmpty ?? false)) ...[
                const Divider(color: DsColors.dividerColorSecondary),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: DsSpacing.verticalSpace8,
                  children: [
                    const DsText.titleMedium(
                      data: 'Features',
                      color: DsColors.textSecondary,
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      primary: false,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: product?.features?.length ?? 0,
                      separatorBuilder: (_, _) =>
                          DsSpacing.verticalSpaceSizedBox8,
                      itemBuilder: (_, index) {
                        final feature = product?.features?[index] ?? '';
                        return Row(
                          spacing: DsSpacing.horizontalSpace12,
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
                            Expanded(
                              child: DsText.bodyMedium(
                                data: feature,
                                color: DsColors.textAccent,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      );
    },
  );
}

class _PricesSection extends StatelessWidget {
  const _PricesSection();

  @override
  Widget build(BuildContext context) => BlocBuilder<PaymentBloc, PaymentState>(
    builder: (context, state) {
      final prices = state.store.pricesResponse?.prices ?? [];
      final selected = state.store.selectedPriceCode;
      return Column(
        spacing: DsSpacing.verticalSpace24,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: DsColors.backgroundPrimary,
              borderRadius: BorderRadius.circular(
                DsBorderRadius.borderRadius12,
              ),
              border: Border.all(
                color: DsColors.borderSubtle,
                width: DsBorderWidth.borderWidth1,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(DsSpacing.radialSpace16),
              child: Column(
                spacing: DsSpacing.verticalSpace12,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const DsText.titleMedium(data: 'Choose a price'),
                  ListView.separated(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: prices.length,
                    separatorBuilder: (_, _) =>
                        DsSpacing.verticalSpaceSizedBox12,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (_, index) {
                      final price = prices[index];
                      final priceCode = price?.priceCode;
                      final amount = price?.amount;
                      final period = price?.billingPeriod ?? '';
                      final isSelected = selected == priceCode;

                      return InkWell(
                        onTap: () => getBloc<PaymentBloc>(
                          context,
                        ).onSelectPrice(priceCode: priceCode),
                        borderRadius: BorderRadius.circular(
                          DsBorderRadius.borderRadius12,
                        ),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? DsColors.backgroundSubtle.withAlpha(60)
                                : DsColors.backgroundSurface,
                            borderRadius: BorderRadius.circular(
                              DsBorderRadius.borderRadius12,
                            ),
                            border: Border.all(
                              color: isSelected
                                  ? DsColors.primary
                                  : DsColors.borderSubtle,
                              width: isSelected
                                  ? DsBorderWidth.borderWidth2
                                  : DsBorderWidth.borderWidth1,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: DsSpacing.radialSpace16,
                              vertical: DsSpacing.radialSpace12,
                            ),
                            child: Row(
                              spacing: DsSpacing.horizontalSpace16,
                              children: [
                                // radio / status
                                Container(
                                  width: 20.r,
                                  height: 20.r,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected
                                          ? DsColors.primary
                                          : DsColors.borderSubtle,
                                      width: DsBorderWidth.borderWidth1,
                                    ),
                                    color: isSelected
                                        ? DsColors.primary
                                        : Colors.transparent,
                                  ),
                                  child: isSelected
                                      ? Icon(
                                          Icons.check,
                                          size: DsSizing.size16,
                                          color: DsColors.iconOnPrimary,
                                        )
                                      : null,
                                ),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      DsText.titleSmall(
                                        data: formatNumberWithSymbol(
                                          amount?.toDouble(),
                                          prefix: NumberFormatSymbol.rupee,
                                        ),
                                      ),
                                      DsSpacing.verticalSpaceSizedBox4,
                                      DsText.bodySmall(
                                        data: period,
                                        color: DsColors.textSecondary,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          DsSpacing.verticalSpaceSizedBox16,
        ],
      );
    },
  );
}

class _PaymentCardShimmer extends StatelessWidget {
  const _PaymentCardShimmer();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: DsSpacing.verticalSpace24,
    children: [
      DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius16),
          border: Border.all(color: DsColors.borderDefault),
        ),
        child: Padding(
          padding: EdgeInsets.all(DsSpacing.radialSpace20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 32.h,
                width: 200.w,
                decoration: BoxDecoration(
                  color: DsColors.backgroundDisabled,
                  borderRadius: BorderRadius.circular(
                    DsBorderRadius.borderRadius8,
                  ),
                ),
              ),
              DsSpacing.verticalSpaceSizedBox8,
              Container(
                height: 20.h,
                width: 150.w,
                decoration: BoxDecoration(
                  color: DsColors.backgroundDisabled,
                  borderRadius: BorderRadius.circular(
                    DsBorderRadius.borderRadius4,
                  ),
                ),
              ),
              DsSpacing.verticalSpaceSizedBox16,
              const Divider(color: DsColors.dividerColorSecondary),
              DsSpacing.verticalSpaceSizedBox16,
              Container(
                height: 24.h,
                width: 100.w,
                decoration: BoxDecoration(
                  color: DsColors.backgroundDisabled,
                  borderRadius: BorderRadius.circular(
                    DsBorderRadius.borderRadius4,
                  ),
                ),
              ),
              DsSpacing.verticalSpaceSizedBox12,
              ListView.separated(
                shrinkWrap: true,
                primary: false,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 3,
                separatorBuilder: (_, _) => DsSpacing.verticalSpaceSizedBox8,
                itemBuilder: (_, _) => Row(
                  children: [
                    Container(
                      width: DsSizing.size16,
                      height: DsSizing.size16,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: DsColors.backgroundDisabled,
                      ),
                    ),
                    DsSpacing.horizontalSpaceSizedBox12,
                    Expanded(
                      child: Container(
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
            ],
          ),
        ),
      ),
      DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius12),
          border: Border.all(color: DsColors.borderSubtle),
        ),
        child: Padding(
          padding: EdgeInsets.all(DsSpacing.radialSpace16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 24.h,
                width: 150.w,
                decoration: BoxDecoration(
                  color: DsColors.backgroundDisabled,
                  borderRadius: BorderRadius.circular(
                    DsBorderRadius.borderRadius4,
                  ),
                ),
              ),
              DsSpacing.verticalSpaceSizedBox12,
              ListView.separated(
                shrinkWrap: true,
                primary: false,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 2,
                separatorBuilder: (_, _) => DsSpacing.verticalSpaceSizedBox12,
                itemBuilder: (_, _) => Container(
                  height: 64.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      DsBorderRadius.borderRadius12,
                    ),
                    color: DsColors.backgroundDisabled,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      Container(
        height: 56.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius22),
          color: DsColors.backgroundDisabled,
        ),
      ),
    ],
  );
}

class _PaymentSuccessForm extends StatelessWidget {
  const _PaymentSuccessForm();

  @override
  Widget build(BuildContext context) => BlocBuilder<PaymentBloc, PaymentState>(
    builder: (context, state) => Padding(
      padding: EdgeInsets.symmetric(
        vertical: DsSpacing.radialSpace24,
        horizontal: DsSpacing.radialSpace12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: DsSpacing.verticalSpace24,
        children: [
          DsLottie(
            lottieUrl: AnimationKeys.successTickAnimation,
            height: 150.h,
            repeat: false,
          ),
          const DsText.headlineMedium(
            data: 'Payment Successful',
            color: DsColors.textSuccess,
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              color: DsColors.backgroundSurface,
              borderRadius: BorderRadius.circular(
                DsBorderRadius.borderRadius12,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: DsSpacing.radialSpace12,
                horizontal: DsSpacing.radialSpace8,
              ),
              child: Column(
                spacing: DsSpacing.verticalSpace8,
                children: [
                  if (state.store.paymentSuccess?.paymentId != null) ...[
                    _PaymentItem(
                      title: 'Payment ID',
                      value: state.store.paymentSuccess?.paymentId ?? '',
                    ),
                  ],
                  if (state.store.paymentSuccess?.orderId != null) ...[
                    _PaymentItem(
                      title: 'Payment ID',
                      value: state.store.paymentSuccess?.orderId ?? '',
                    ),
                  ],
                  if (state.store.checkoutSession?.providerSubscriptionId !=
                      null) ...[
                    _PaymentItem(
                      title: 'Subscription ID',
                      value:
                          state.store.checkoutSession?.providerSubscriptionId ??
                          '',
                    ),
                  ],
                  if (state.store.checkoutSession?.amount != null) ...[
                    _PaymentItem(
                      title: 'Amount',
                      value: formatNumberWithSymbol(
                        state.store.checkoutSession?.amount?.toDouble(),
                        prefix: NumberFormatSymbol.rupee,
                      ),
                    ),
                  ],
                  if (state.store.billingProductInfo?.displayName?.isNotEmpty ??
                      false) ...[
                    _PaymentItem(
                      title: 'Plan Name',
                      value: state.store.billingProductInfo?.displayName ?? '',
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _PaymentItem extends StatelessWidget {
  const _PaymentItem({required this.title, required this.value});

  final String? title;
  final String? value;

  @override
  Widget build(BuildContext context) => Row(
    spacing: DsSpacing.horizontalSpace4,
    children: [
      Expanded(
        child: DsText.bodyMedium(
          data: title ?? '',
          color: DsColors.textSecondary,
        ),
      ),
      DsText.bodyMedium(data: value ?? '', color: DsColors.textPrimary),
    ],
  );
}
