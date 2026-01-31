part of 'features_page.dart';

class _FeaturesForm extends StatelessWidget {
  const _FeaturesForm();

  @override
  Widget build(BuildContext context) => RefreshIndicator(
    onRefresh: () async => getBloc<ProductFeaturesBloc>(context).started(),
    child: SafeArea(
      child: BlocBuilder<ProductFeaturesBloc, ProductFeaturesState>(
        builder: (context, state) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: DsSpacing.radialSpace24,
              horizontal: DsSpacing.radialSpace16,
            ),
            child: DsShimmer(
              enabled: state.store.loading,
              child: Visibility(
                visible: !state.store.loading,
                replacement: const _FeaturePageShimmer(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: DsSpacing.verticalSpace12,
                  children: [
                    DsText.headlineLarge(
                      data:
                          'Hi ${globalState.store.userInfo?.firstName?.input},',
                    ),
                    const _RecentActivitiesSection(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class _RecentActivitiesSection extends StatelessWidget {
  const _RecentActivitiesSection();

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ProductFeaturesBloc, ProductFeaturesState>(
        builder: (context, state) {
          final activities = state.store.userActivityInfo?.userActivities ?? [];
          if (activities.isEmpty) {
            return const DsText.bodyMedium(
              data: 'Interact with your docs to get started',
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: DsSpacing.verticalSpace12,
            children: [
              const DsText.titleLarge(
                data: 'Recent Activities',
                color: DsColors.textPrimary,
              ),
              ListView.separated(
                scrollDirection: Axis.vertical,
                itemCount: activities.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                primary: false,
                separatorBuilder: (_, _) => DsSpacing.verticalSpaceSizedBox8,
                itemBuilder: (context, index) {
                  final activity = activities[index];
                  if (activity == null) return const SizedBox();
                  return DsListTile(
                    onTap: () {},
                    backgroundColor: DsColors.backgroundPrimary,
                    borderRadius: BorderRadius.circular(
                      DsBorderRadius.borderRadius8,
                    ),
                    borderColor: DsColors.borderSubtle,
                    borderWidth: DsBorderWidth.borderWidth1,
                    leading: Container(
                      padding: EdgeInsets.all(DsSpacing.radialSpace8),
                      decoration: BoxDecoration(
                        color: DsColors.backgroundInfo.withAlpha(30),
                        borderRadius: BorderRadius.circular(
                          DsBorderRadius.borderRadius12,
                        ),
                      ),
                      child: Icon(
                        Icons.description_rounded,
                        color: DsColors.primary,
                        size: DsSizing.size24,
                      ),
                    ),
                    title: ListTileTitleRich(
                      richText: RichText(
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          style: DsTextStyle.bodyMedium.copyWith(
                            color: DsColors.textPrimary,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  '''${_getActionText(activity.lastAction)} ''',
                            ),
                            TextSpan(
                              text: activity.fileName ?? '',
                              style: DsTextStyle.bodyMedium.copyWith(
                                color: DsColors.textAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    subtitle: ListTileSubtitleMedium(
                      data: getTimeAgo(activity.dominantAt),
                      color: DsColors.textSecondary,
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: DsColors.iconDisabled,
                      size: DsSizing.size20,
                    ),
                  );
                },
              ),
            ],
          );
        },
      );

  String _getActionText(UserActivityType? type) => switch (type) {
    UserActivityType.documentChat => 'Chat with',
    UserActivityType.documentUpload => 'Uploaded',
    UserActivityType.documentView => 'Viewed',
    UserActivityType.documentLiveChat => 'Live Chat with',
    UserActivityType.documentOcr => 'OCR on',
    UserActivityType.documentSummary => 'Summarized',
    _ => 'Activity',
  };
}

class _FeaturePageShimmer extends StatelessWidget {
  const _FeaturePageShimmer();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 24.h,
            width: 140.w,
            decoration: BoxDecoration(
              color: DsColors.backgroundDisabled,
              borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius4),
            ),
          ),
          Container(
            height: 16.h,
            width: 50.w,
            decoration: BoxDecoration(
              color: DsColors.backgroundDisabled,
              borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius4),
            ),
          ),
        ],
      ),
      DsSpacing.verticalSpaceSizedBox16,
      const _ActivityShimmerCard(),
      DsSpacing.verticalSpaceSizedBox12,
      const _ActivityShimmerCard(),
      DsSpacing.verticalSpaceSizedBox32,
      Container(
        height: 24.h,
        width: 160.w,
        decoration: BoxDecoration(
          color: DsColors.backgroundDisabled,
          borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius4),
        ),
      ),
      DsSpacing.verticalSpaceSizedBox8,
      Container(
        height: 16.h,
        width: 200.w,
        decoration: BoxDecoration(
          color: DsColors.backgroundDisabled,
          borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius4),
        ),
      ),
      DsSpacing.verticalSpaceSizedBox24,
      Row(
        children: [
          const Expanded(child: _FeatureShimmerCard()),
          DsSpacing.horizontalSpaceSizedBox16,
          const Expanded(child: _FeatureShimmerCard()),
        ],
      ),
      DsSpacing.verticalSpaceSizedBox16,
      Row(
        children: [
          const Expanded(child: _FeatureShimmerCard()),
          DsSpacing.horizontalSpaceSizedBox16,
          const Expanded(child: _FeatureShimmerCard()),
        ],
      ),
    ],
  );
}

class _ActivityShimmerCard extends StatelessWidget {
  const _ActivityShimmerCard();

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(DsSpacing.radialSpace16),
    decoration: BoxDecoration(
      color: DsColors.backgroundPrimary,
      borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius16),
      border: Border.all(color: DsColors.borderSubtle),
    ),
    child: Row(
      children: [
        Container(
          height: 44.r,
          width: 44.r,
          decoration: BoxDecoration(
            color: DsColors.backgroundDisabled,
            borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius12),
          ),
        ),
        DsSpacing.horizontalSpaceSizedBox12,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 16.h,
                width: 150.w,
                decoration: BoxDecoration(
                  color: DsColors.backgroundDisabled,
                  borderRadius: BorderRadius.circular(
                    DsBorderRadius.borderRadius4,
                  ),
                ),
              ),
              DsSpacing.verticalSpaceSizedBox8,
              Container(
                height: 12.h,
                width: 80.w,
                decoration: BoxDecoration(
                  color: DsColors.backgroundDisabled,
                  borderRadius: BorderRadius.circular(
                    DsBorderRadius.borderRadius4,
                  ),
                ),
              ),
            ],
          ),
        ),
        Icon(
          Icons.chevron_right,
          color: DsColors.backgroundDisabled,
          size: DsSizing.size24,
        ),
      ],
    ),
  );
}

class _FeatureShimmerCard extends StatelessWidget {
  const _FeatureShimmerCard();

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(DsSpacing.radialSpace16),
    decoration: BoxDecoration(
      color: DsColors.backgroundPrimary,
      borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius16),
      border: Border.all(color: DsColors.borderSubtle),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 40.r,
          width: 40.r,
          decoration: BoxDecoration(
            color: DsColors.backgroundDisabled,
            borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius12),
          ),
        ),
        DsSpacing.verticalSpaceSizedBox16,
        Container(
          height: 16.h,
          width: 60.w,
          decoration: BoxDecoration(
            color: DsColors.backgroundDisabled,
            borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius4),
          ),
        ),
        DsSpacing.verticalSpaceSizedBox12,
        Container(
          height: 12.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: DsColors.backgroundDisabled,
            borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius4),
          ),
        ),
        DsSpacing.verticalSpaceSizedBox4,
        Container(
          height: 12.h,
          width: 80.w,
          decoration: BoxDecoration(
            color: DsColors.backgroundDisabled,
            borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius4),
          ),
        ),
      ],
    ),
  );
}
