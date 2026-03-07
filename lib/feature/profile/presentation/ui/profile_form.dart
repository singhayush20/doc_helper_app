part of 'profile_page.dart';

class _ProfileForm extends StatelessWidget {
  const _ProfileForm();

  @override
  Widget build(BuildContext context) => RefreshIndicator(
    onRefresh: () async => getBloc<ProfileBloc>(context).onProfileRefreshed(),
    child: BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) => SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: DsSpacing.radialSpace16,
            vertical: DsSpacing.radialSpace24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: DsSpacing.verticalSpace24,
            children: [
              _UserInfoSection(),
              if (state.store.usageInfo != null ||
                  (state
                          .store
                          .productFeaturesUsageInfo
                          ?.usageInfo
                          ?.isNotEmpty ??
                      false)) ...[
                _UsageSection(),
              ],
              if (state.store.subscriptionInfo != null) ...[
                const _SubscriptionSection(),
              ],
              _SettingsSection(),
              DsButton.secondary(
                data: 'Log Out',
                onTap: () => getBloc<ProfileBloc>(context).onLogoutPressed(),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _UserInfoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BlocBuilder<ProfileBloc, ProfileState>(
    builder: (context, state) => DecoratedBox(
      decoration: BoxDecoration(
        color: DsColors.backgroundPrimary,
        borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius12),
      ),
      child: Padding(
        padding: EdgeInsets.all(DsSpacing.radialSpace16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: DsSpacing.verticalSpace12,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              spacing: DsSpacing.verticalSpace8,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DsText.titleLarge(data: 'Full Name'),
                DsText.bodyLarge(
                  data:
                      '''${state.store.userInfo?.firstName?.input ?? ''} ${state.store.userInfo?.lastName?.input ?? ''}''',
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              spacing: DsSpacing.verticalSpace8,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DsText.titleLarge(data: 'Email Address'),
                DsText.bodyLarge(data: '${state.store.userInfo?.email?.input}'),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

class _UsageSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BlocBuilder<ProfileBloc, ProfileState>(
    builder: (context, state) {
      final usageInfo = state.store.usageInfo;
      if (usageInfo == null) return const SizedBox.shrink();

      final limit = usageInfo.monthlyLimit ?? 0;
      final usage = usageInfo.currentMonthlyUsage ?? 0;

      final resetDate = usageInfo.resetDate;
      final dateStr = getMonthNameDateYear(resetDate);

      return Column(
        spacing: DsSpacing.verticalSpace12,
        children: [
          Container(
            padding: EdgeInsets.all(DsSpacing.radialSpace16),
            decoration: BoxDecoration(
              color: DsColors.backgroundPrimary,
              borderRadius: BorderRadius.circular(
                DsBorderRadius.borderRadius12,
              ),
              border: Border.all(color: DsColors.borderSubtle),
            ),
            child: DsUsageIndicator(
              title: 'Chat Usage',
              currentUsage: usage,
              totalLimit: limit,
              unit: 'tokens',
              resetDate: dateStr,
            ),
          ),
          Container(
            padding: EdgeInsets.all(DsSpacing.radialSpace16),
            decoration: BoxDecoration(
              color: DsColors.backgroundPrimary,
              borderRadius: BorderRadius.circular(
                DsBorderRadius.borderRadius12,
              ),
              border: Border.all(color: DsColors.borderSubtle),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              primary: false,
              itemBuilder: (_, index) {
                final usageData =
                    state.store.productFeaturesUsageInfo?.usageInfo?[index];

                if (usageData != null) {
                  return DsUsageIndicator(
                    title: usageData.name ?? '',
                    currentUsage: usageData.usageInfo?.used ?? 0,
                    totalLimit: usageData.usageInfo?.limit ?? 0,
                    unit: 'tokens',
                    resetDate: getMonthNameDateYear(
                      usageData.usageInfo?.resetAt,
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
              separatorBuilder: (_, index) {
                final usageData =
                    state.store.productFeaturesUsageInfo?.usageInfo?[index];
                if (usageData != null) {
                  return DsSpacing.verticalSpaceSizedBox4;
                } else {
                  return const SizedBox();
                }
              },
              itemCount:
                  state.store.productFeaturesUsageInfo?.usageInfo?.length ?? 0,
            ),
          ),
        ],
      );
    },
  );
}

class _SubscriptionSection extends StatelessWidget {
  const _SubscriptionSection();

  @override
  Widget build(BuildContext context) => BlocBuilder<ProfileBloc, ProfileState>(
    builder: (context, state) =>
        (state.store.subscriptionInfo?.planName == null)
        ? const _FreePlanBanner()
        : const _CurrentPlanBanner(),
  );
}

class _CurrentPlanBanner extends StatelessWidget {
  const _CurrentPlanBanner();

  @override
  Widget build(BuildContext context) => BlocBuilder<ProfileBloc, ProfileState>(
    builder: (context, state) {
      final subscriptionInfo = state.store.subscriptionInfo;
      return DecoratedBox(
        decoration: BoxDecoration(
          color: DsColors.backgroundInfo,
          border: Border.all(color: DsColors.borderPrimary),
          borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius8),
        ),
        child: Padding(
          padding: EdgeInsets.all(DsSpacing.radialSpace20),
          child: Column(
            spacing: DsSpacing.verticalSpace8,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                spacing: DsSpacing.verticalSpace4,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    spacing: DsSpacing.horizontalSpace4,
                    children: [
                      Expanded(
                        child: DsText.titleLarge(
                          data: subscriptionInfo?.planName ?? '',
                        ),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            DsBorderRadius.borderRadius22,
                          ),
                          color: DsColors.backgroundSuccess,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: DsSpacing.radialSpace8,
                            vertical: DsSpacing.radialSpace4,
                          ),
                          child: DsText.bodyMedium(
                            data: subscriptionInfo?.status ?? '',
                            color: DsColors.textOnDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                  DsText.bodyMedium(data: subscriptionInfo?.description ?? ''),
                  if (subscriptionInfo?.cancelAtPeriodEnd ?? false) ...[
                    const DsText.bodyMedium(
                      data:
                          '''Your planned is marked for cancellation. You will not be charged after the current billing cycle''',
                    ),
                  ],
                ],
              ),
              const Divider(color: DsColors.dividerColor),
              Column(
                spacing: DsSpacing.verticalSpace16,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: DsSpacing.verticalSpace8,
                    children: [
                      _CurrentPlanInfoItem(
                        title: 'Plan Price',
                        value: formatNumberWithSymbol(
                          subscriptionInfo?.amount?.toDouble(),
                          prefix: NumberFormatSymbol.rupee,
                        ),
                      ),
                      _CurrentPlanInfoItem(
                        title: 'Plan Start Date',
                        value:
                            subscriptionInfo?.currentPeriodStart
                                ?.toDayMonthYear() ??
                            '',
                      ),
                      _CurrentPlanInfoItem(
                        title: 'Plan End Date',
                        value:
                            subscriptionInfo?.currentPeriodEnd
                                ?.toDayMonthYear() ??
                            '',
                      ),
                    ],
                  ),
                  DsButton.primary(
                    data: 'Manage Plan',
                    onTap: () => getBloc<ProfileBloc>(
                      context,
                    ).onManageSubscriptionTapped(),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _CurrentPlanInfoItem extends StatelessWidget {
  const _CurrentPlanInfoItem({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) => Row(
    spacing: DsSpacing.horizontalSpace4,
    children: [
      Expanded(child: DsText.titleMedium(data: title)),
      DsText.bodyMedium(data: value),
    ],
  );
}

class _FreePlanBanner extends StatelessWidget {
  const _FreePlanBanner();

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(DsSpacing.radialSpace16),
    decoration: BoxDecoration(
      color: DsColors.primary,
      borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius12),
    ),
    child: Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: DsColors.white.withAlpha(20),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.diamond_outlined, color: DsColors.white),
            ),
            DsSpacing.horizontalSpaceSizedBox12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: DsSpacing.verticalSpace4,
                children: [
                  const DsText.titleMedium(
                    data: 'Premium Plan',
                    color: DsColors.white,
                  ),
                  const DsText.bodySmall(
                    data: 'Upgrade today, to get more features',
                    color: DsColors.textTertiary,
                  ),
                ],
              ),
            ),
          ],
        ),
        DsSpacing.verticalSpaceSizedBox16,
        SizedBox(
          width: double.infinity,
          child: DsButton.secondary(
            data: 'Upgrade',
            onTap: () =>
                getBloc<ProfileBloc>(context).onManageSubscriptionTapped(),
          ),
        ),
      ],
    ),
  );
}

class _SettingsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(DsSpacing.radialSpace16),
    decoration: BoxDecoration(
      color: DsColors.backgroundPrimary,
      borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DsText.titleLarge(data: 'Settings'),
        DsSpacing.verticalSpaceSizedBox16,
        DsListTile(
          leading: Icon(Icons.lock_outline, size: DsSizing.size24),
          title: const ListTileTitleMedium(data: 'Change Password'),
          trailing: Icon(Icons.chevron_right, size: DsSizing.size24),
          onTap: () => getBloc<ProfileBloc>(context).onPasswordResetPressed(),
        ),
      ],
    ),
  );
}
