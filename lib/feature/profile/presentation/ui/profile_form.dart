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
