part of 'summary_page.dart';

class _SummaryForm extends StatelessWidget {
  const _SummaryForm();

  @override
  Widget build(BuildContext context) => BlocBuilder<SummaryBloc, SummaryState>(
    builder: (context, state) {
      final isLoading = state.store.loading;
      final hasData = state.store.docSummaries != null;

      return DsShimmer(
        enabled: isLoading && !hasData,
        child: Visibility(
          visible: !isLoading || hasData,
          replacement: const _SummaryShimmer(),
          child: (state.store.docSummaries == null)
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: DsSpacing.radialSpace24,
                      horizontal: DsSpacing.radialSpace12,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: DsSpacing.verticalSpace8,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        DsImage(
                          mediaUrl: getAssetUrlForImageKey(
                            imageKey: ImageKeys.errorIcon,
                          ),
                          height: 48.h,
                        ),
                        const DsText.headlineSmall(
                          data: 'Something went wrong. Please try again!',
                          color: DsColors.textSecondary,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: DsButton.primary(
                            data: 'Try Again',
                            onTap: () {
                              final args = GoRouterState.of(
                                context,
                              ).uri.queryParameters;
                              getBloc<SummaryBloc>(context).started(args: args);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          horizontal: DsSpacing.radialSpace16,
                          vertical: DsSpacing.radialSpace20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          spacing: DsSpacing.verticalSpace24,
                          children: [
                            if (state.store.docSummaries?.isNotEmpty ??
                                false) ...[
                              const _VersionSelector(),
                              const _SectionHeader(
                                title: 'Summary',
                                icon: Icons.auto_awesome_rounded,
                              ),
                              const _SummaryCard(),
                            ],
                            DsSpacing.verticalSpaceSizedBox8,
                          ],
                        ),
                      ),
                    ),
                    const _SummaryActionBottomBar(),
                  ],
                ),
        ),
      );
    },
  );
}

class _VersionSelector extends StatelessWidget {
  const _VersionSelector();

  @override
  Widget build(BuildContext context) => BlocBuilder<SummaryBloc, SummaryState>(
    builder: (context, state) {
      final summaries = state.store.docSummaries;
      final currentIndex = state.store.currentSummaryIndex;
      final isLoading = state.store.loading;
      final totalVersions = (summaries?.length ?? 0) + (isLoading ? 1 : 0);

      if (totalVersions != 0) {
        final isShowingLoadingVersion =
            isLoading && currentIndex == (summaries?.length ?? 0);
        final summaryInfo = isShowingLoadingVersion
            ? null
            : summaries?.elementAtOrNull(currentIndex ?? 0);

        return DecoratedBox(
          decoration: BoxDecoration(
            color: DsColors.backgroundSurface,
            borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius12),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: DsSpacing.radialSpace8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: (currentIndex != null && currentIndex > 0)
                      ? () => getBloc<SummaryBloc>(
                          context,
                        ).onSummaryIndexChanged(index: currentIndex - 1)
                      : null,
                  icon: const Icon(
                    Icons.chevron_left_rounded,
                    color: DsColors.primary,
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      DsText.titleSmall(
                        data:
                            '''Version ${(currentIndex ?? 0) + 1} of $totalVersions''',
                      ),
                      if (isShowingLoadingVersion) ...[
                        const DsText.labelSmall(
                          data: 'Generating new summary...',
                          color: DsColors.textTertiary,
                        ),
                      ] else ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: DsSpacing.horizontalSpace4,
                          children: [
                            Flexible(
                              child: DsText.labelSmall(
                                data:
                                    '''Tone: ${summaryInfo?.tone?.name.toString().toUpperCase()}''',
                                color: DsColors.textTertiary,
                              ),
                            ),
                            Flexible(
                              child: DsText.labelSmall(
                                data:
                                    '''Length: ${summaryInfo?.length?.name.toString().toUpperCase()}''',
                                color: DsColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                IconButton(
                  onPressed:
                      (currentIndex != null && currentIndex < totalVersions - 1)
                      ? () => getBloc<SummaryBloc>(
                          context,
                        ).onSummaryIndexChanged(index: currentIndex + 1)
                      : null,
                  icon: const Icon(
                    Icons.chevron_right_rounded,
                    color: DsColors.primary,
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        return const SizedBox();
      }
    },
  );
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Row(
    spacing: DsSpacing.horizontalSpace12,
    children: [
      Icon(icon, color: DsColors.iconSecondary, size: DsSizing.size24),
      DsText.titleLarge(data: title, color: DsColors.textPrimary),
    ],
  );
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard();

  @override
  Widget build(BuildContext context) => BlocBuilder<SummaryBloc, SummaryState>(
    builder: (context, state) {
      final summaries = state.store.docSummaries;
      final currentIndex = state.store.currentSummaryIndex;
      final isLoading = state.store.loading;
      final isShowingLoadingVersion =
          isLoading && currentIndex == (summaries?.length ?? 0);

      return DecoratedBox(
        decoration: BoxDecoration(
          color: DsColors.white,
          borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius16),
          border: Border.all(color: DsColors.borderSubtle),
          boxShadow: [
            BoxShadow(
              color: DsColors.black.withAlpha(10),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(DsSpacing.radialSpace20),
          child: isShowingLoadingVersion
              ? const _TextShimmer()
              : GptMarkdown(
                  summaries?.elementAtOrNull(currentIndex ?? 0)?.content ?? '',
                  style: TextStyle(fontSize: DsSizing.size16),
                ),
        ),
      );
    },
  );
}

class _TextShimmer extends StatelessWidget {
  const _TextShimmer();

  @override
  Widget build(BuildContext context) => DsShimmer(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: DsSpacing.verticalSpace12,
      children: [
        Container(
          height: 14.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: DsColors.backgroundDisabled,
            borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius4),
          ),
        ),
        Container(
          height: 14.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: DsColors.backgroundDisabled,
            borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius4),
          ),
        ),
        Container(
          height: 14.h,
          width: 0.7.w,
          decoration: BoxDecoration(
            color: DsColors.backgroundDisabled,
            borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius4),
          ),
        ),
        DsSpacing.verticalSpaceSizedBox12,
        Container(
          height: 14.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: DsColors.backgroundDisabled,
            borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius4),
          ),
        ),
        Container(
          height: 14.h,
          width: 0.4.w,
          decoration: BoxDecoration(
            color: DsColors.backgroundDisabled,
            borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius4),
          ),
        ),
      ],
    ),
  );
}

class _SummaryActionBottomBar extends StatelessWidget {
  const _SummaryActionBottomBar();

  @override
  Widget build(BuildContext context) => BlocBuilder<SummaryBloc, SummaryState>(
    builder: (context, state) => Container(
      padding: EdgeInsets.all(DsSpacing.radialSpace16),
      decoration: const BoxDecoration(
        color: DsColors.white,
        border: Border(top: BorderSide(color: DsColors.borderSubtle)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: DsSpacing.verticalSpace12,
        children: [
          DsButton.secondary(
            data: 'Regenerate Summary',
            onTap: state.store.loading
                ? null
                : () => getBloc<SummaryBloc>(
                    context,
                  ).onSummarySettingsDialogRequested(),
            leadingIcon: Icons.refresh_rounded,
          ),
          Row(
            spacing: DsSpacing.horizontalSpace12,
            children: [
              Expanded(
                child: DsButton.primary(
                  data: 'Save',
                  onTap: () {},
                  leadingIcon: Icons.bookmark_rounded,
                ),
              ),
              Expanded(
                child: DsButton.primary(
                  data: 'Share',
                  onTap: () {},
                  leadingIcon: Icons.share_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

void _showSummarySettingsDialog(BuildContext context, SummaryStateStore store) {
  SummaryTone selectedTone =
      store.docSummaries?.lastOrNull?.tone ?? SummaryTone.casual;
  SummaryLength selectedLength =
      store.docSummaries?.lastOrNull?.length ?? SummaryLength.short;

  DsDialog.showDialog(
    context: context,
    title: 'Summary Settings',
    description: 'Fine-tune your document regeneration',
    showDefaultIcon: false,
    content: StatefulBuilder(
      builder: (context, setState) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: DsSpacing.verticalSpace24,
        children: [
          PreferenceToggleGroup<SummaryTone>(
            label: 'SUMMARY TONE',
            icon: Icons.tune_rounded,
            options: [...SummaryTone.values],
            selectedOption: selectedTone,
            onSelected: (tone) => setState(() => selectedTone = tone),
          ),
          PreferenceToggleGroup<SummaryLength>(
            label: 'SUMMARY LENGTH',
            icon: Icons.linear_scale_rounded,
            options: [...SummaryLength.values],
            selectedOption: selectedLength,
            onSelected: (length) => setState(() => selectedLength = length),
          ),
        ],
      ),
    ),
    primaryButtonText: 'Regenerate Summary',
    primaryButtonLeadingIcon: Icons.refresh_rounded,
    onPrimaryButtonTap: () {
      getBloc<SummaryBloc>(context).regenerateSummary(
        documentId: store.documentId ?? -1,
        tone: selectedTone,
        length: selectedLength,
      );
    },
    secondaryAction: DsTextButton.secondary(
      data: 'Cancel and Keep Current',
      onTap: () => GoRouter.of(context).pop(),
    ),
  );
}

class _SummaryShimmer extends StatelessWidget {
  const _SummaryShimmer();

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: EdgeInsets.all(DsSpacing.radialSpace16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: DsSpacing.verticalSpace24,
      children: [
        Container(
          height: 56.h,
          decoration: BoxDecoration(
            color: DsColors.backgroundDisabled,
            borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius12),
          ),
        ),
        Row(
          spacing: DsSpacing.horizontalSpace12,
          children: [
            Container(
              width: 24.w,
              height: 24.h,
              decoration: const BoxDecoration(
                color: DsColors.backgroundDisabled,
                shape: BoxShape.circle,
              ),
            ),
            Container(
              width: 150.w,
              height: 24.h,
              color: DsColors.backgroundDisabled,
            ),
          ],
        ),
        const _TextShimmer(),
      ],
    ),
  );
}
