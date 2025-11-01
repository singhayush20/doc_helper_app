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
