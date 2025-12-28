part of 'profile_page.dart';

class _ProfileForm extends StatelessWidget {
  const _ProfileForm();

  @override
  Widget build(BuildContext context) => BlocBuilder<ProfileBloc, ProfileState>(
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
            const DsText.titleLarge(data: 'My Account'),
            _UserInfoSection(),
            if (state.store.usageInfo != null) ...[_UsageSection()],
            if (state.store.subscriptionInfo != null) ...[ _SubscriptionSection()],
            _SettingsSection(),
            DsButton.secondary(
              data: 'Log Out',
              onTap: () => getBloc<ProfileBloc>(context).onLogoutPressed(),
            ),
          ],
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

      final limit = usageInfo.monthlyLimit ?? 5000;
      final usage = usageInfo.currentMonthlyUsage ?? 0;
      final percentage = (usage / limit).clamp(0.0, 1.0);

      final resetDate = usageInfo.resetDate;
      final dateStr = resetDate != null
          ? '${_monthName(resetDate.month)} ${resetDate.day}, ${resetDate.year}'
          : '';

      return Container(
        padding: EdgeInsets.all(DsSpacing.radialSpace16),
        decoration: BoxDecoration(
          color: DsColors.backgroundPrimary,
          borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius12),
          border: Border.all(color: DsColors.borderSubtle),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: DsSpacing.horizontalSpace4,
              children: [
                const Expanded(
                  child: DsText.titleMedium(data: 'Monthly Usage'),
                ),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: DsColors.textPrimary),
                    children: [
                      TextSpan(
                        text: _formatNumber(usage),
                        style: DsTextStyle.bodyMedium.copyWith(
                          color: DsColors.textSecondary,
                        ),
                      ),
                      TextSpan(
                        text: ' / ${_formatNumber(limit)} tokens',
                        style: DsTextStyle.bodyMedium.copyWith(
                          color: DsColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            DsSpacing.verticalSpaceSizedBox8,
            ClipRRect(
              borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius4),
              child: LinearProgressIndicator(
                value: percentage,
                minHeight: 6,
                backgroundColor: DsColors.backgroundDisabled,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  DsColors.primary,
                ),
              ),
            ),
            DsSpacing.verticalSpaceSizedBox8,
            if (dateStr.isNotEmpty)
              DsText.bodySmall(
                data: 'Resets on $dateStr',
                color: DsColors.textSecondary,
              ),
          ],
        ),
      );
    },
  );

  String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    if (month < 1 || month > 12) return '';
    return months[month - 1];
  }

  String _formatNumber(int number) {
    final str = number.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(str[i]);
    }
    return buffer.toString();
  }
}

class _SubscriptionSection extends StatelessWidget {
  const _SubscriptionSection({super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(DsSpacing.radialSpace16),
    decoration: BoxDecoration(
      color: DsColors.backgroundPrimary,
      borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius12),
      border: Border.all(color: DsColors.borderSubtle),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DsText.titleLarge(data: 'Plan Information'),
                DsSpacing.verticalSpaceSizedBox4,
                const DsText.bodySmall(
                  data: 'Subscription Details',
                  color: DsColors.textSecondary,
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: DsColors.backgroundSurface,
                borderRadius: BorderRadius.circular(100),
              ),
              child: const DsText.bodySmall(
                data: 'FREE TIER',
                color: DsColors.textSecondary,
              ),
            ),
          ],
        ),
        DsSpacing.verticalSpaceSizedBox24,

        // Details
        const _DetailRow(label: 'Plan Name', value: 'Basic Starter'),
        DsSpacing.verticalSpaceSizedBox12,
        const _DetailRow(label: 'Price', value: '\$0.00 USD'),
        DsSpacing.verticalSpaceSizedBox12,
        const _DetailRow(label: 'Token Limit', value: '5,000 / mo'),
        DsSpacing.verticalSpaceSizedBox12,

        // Description
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const DsText.bodyMedium(
              data: 'Description',
              color: DsColors.textSecondary,
            ),
            const SizedBox(width: 16),
            Flexible(
              child: const DsText.bodyMedium(
                data: 'Essential tools for personal document analysis.',
                textAlign: TextAlign.end,
                color: DsColors.textPrimary,
              ),
            ),
          ],
        ),

        DsSpacing.verticalSpaceSizedBox24,

        // Pro Banner
        Container(
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
                      color: DsColors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.diamond_outlined, color: DsColors.white),
                  ),
                  DsSpacing.horizontalSpaceSizedBox12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const DsText.titleMedium(
                          data: 'Unlock Pro Features',
                          color: DsColors.white,
                        ),
                        DsText.bodySmall(
                          data: 'Get 50k tokens, priority support & more.',
                          color: DsColors.white.withOpacity(0.8),
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
                  data: 'Upgrade to Pro \u2192',
                  onTap: () {},
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DsText.bodyMedium(data: label, color: DsColors.textSecondary),
        DsText.titleMedium(data: value, color: DsColors.textPrimary),
      ],
    );
  }
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
        DsListTile(
          leading: Icon(Icons.notifications_outlined, size: DsSizing.size24),
          title: const ListTileTitleMedium(data: 'Notification Settings'),
          trailing: Icon(Icons.chevron_right, size: DsSizing.size24),
          onTap: () {},
        ),
      ],
    ),
  );
}
