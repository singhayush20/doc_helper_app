part of 'profile_page.dart';

class _ProfileForm extends StatelessWidget {
  const _ProfileForm();

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
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
          _SubscriptionSection(),
          _SettingsSection(),
          DsButton.secondary(
            data: 'Log Out',
            onTap: () => getBloc<ProfileBloc>(context).onLogoutPressed(),
          ),
        ],
      ),
    ),
  );
}

class _UserInfoSection extends StatelessWidget {
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
        const DsText.titleMedium(data: 'User Information'),
        DsSpacing.verticalSpaceSizedBox16,
        const DsText.bodySmall(data: 'Full Name'),
        const DsText.titleMedium(data: 'Jane Doe'),
        DsSpacing.verticalSpaceSizedBox16,
        const DsText.bodySmall(data: 'Email Address'),
        const DsText.titleMedium(data: 'janedoe@email.com'),
      ],
    ),
  );
}

class _SubscriptionSection extends StatelessWidget {
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
        const DsText.titleMedium(data: 'Subscription'),
        const DsText.bodySmall(data: 'You are on the Free Plan'),
        DsSpacing.verticalSpaceSizedBox16,
        Container(
          padding: EdgeInsets.all(DsSpacing.radialSpace16),
          decoration: BoxDecoration(
            color: DsColors.backgroundSuccess,
            borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius8),
          ),
          child: Row(
            children: [
              const Expanded(
                child: DsText.bodyBoldSmall(
                  data:
                      '''Unlock unlimited document uploads and advanced features.''',
                ),
              ),
              DsSpacing.horizontalSpaceSizedBox16,
              DsButton.primary(data: 'Upgrade to Pro', onTap: () {}),
            ],
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
        const DsText.titleMedium(data: 'Settings'),
        DsSpacing.verticalSpaceSizedBox16,
        DsListTile(
          leading: const Icon(Icons.lock_outline),
          title: const ListTileTitleMedium(data: 'Change Password'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {},
        ),
        DsListTile(
          leading: const Icon(Icons.notifications_outlined),
          title: const ListTileTitleMedium(data: 'Notification Settings'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {},
        ),
      ],
    ),
  );
}
