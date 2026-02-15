part of 'summary_page.dart';

class _SummaryForm extends StatelessWidget {
  const _SummaryForm();

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<DocSummarizerBloc, DocSummarizerState>(
        builder: (context, state) => DsShimmer(
          enabled: state.store.loading,
          child: Visibility(
            visible: !state.store.loading,
            replacement: const _SummaryShimmer(),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: DsSpacing.radialSpace16,
                vertical: DsSpacing.radialSpace20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: DsSpacing.verticalSpace24,
                children: [
                  const _VersionSelector(),
                  const _SectionHeader(
                    title: 'Executive Summary',
                    icon: Icons.auto_awesome_rounded,
                  ),
                  const _ExecutiveSummaryCard(),
                  const DsText.titleLarge(data: 'Key Takeaways'),
                  const _KeyTakeawaysList(),
                  const DsText.titleLarge(data: 'Detailed Analysis'),
                  const _DetailedAnalysisSection(),
                  DsSpacing.verticalSpaceSizedBox64, // Space for bottom bar
                ],
              ),
            ),
          ),
        ),
      );
}

class _VersionSelector extends StatelessWidget {
  const _VersionSelector();

  @override
  Widget build(BuildContext context) => DecoratedBox(
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
            onPressed: () {},
            icon: const Icon(
              Icons.chevron_left_rounded,
              color: DsColors.primary,
            ),
          ),
          const Column(
            children: [
              DsText.titleSmall(data: 'Version 2 of 3'),
              DsText.labelSmall(
                data: 'REFINED ANALYSIS',
                color: DsColors.textTertiary,
              ),
            ],
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.chevron_right_rounded,
              color: DsColors.primary,
            ),
          ),
        ],
      ),
    ),
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
      Icon(icon, color: Colors.orangeAccent, size: DsSizing.size24),
      DsText.titleLarge(data: title, color: DsColors.textPrimary),
    ],
  );
}

class _ExecutiveSummaryCard extends StatelessWidget {
  const _ExecutiveSummaryCard();

  @override
  Widget build(BuildContext context) => DecoratedBox(
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
      child: const DsText.bodyMedium(
        data:
            'This document outlines the strategic roadmap for the upcoming fiscal year, focusing on market expansion in APAC regions and internal digital transformation initiatives to reduce operational overhead by 15%.',
      ),
    ),
  );
}

class _KeyTakeawaysList extends StatelessWidget {
  const _KeyTakeawaysList();

  @override
  Widget build(BuildContext context) => Column(
    spacing: DsSpacing.verticalSpace16,
    children: const [
      _TakeawayItem(
        title: 'Expansion focus:',
        description:
            'Identify emerging markets in Southeast Asia as primary growth drivers.',
      ),
      _TakeawayItem(
        title: 'Tech Stack:',
        description:
            'Migrate legacy systems to a cloud-native architecture by Q3.',
      ),
      _TakeawayItem(
        title: 'Budgeting:',
        description:
            'Reallocate 20% of R&D budget towards customer experience automation.',
      ),
    ],
  );
}

class _TakeawayItem extends StatelessWidget {
  const _TakeawayItem({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: DsSpacing.horizontalSpace12,
    children: [
      DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.orange.withAlpha(30),
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: EdgeInsets.all(DsSpacing.radialSpace4),
          child: const Icon(
            Icons.check_rounded,
            color: Colors.orange,
            size: 16,
          ),
        ),
      ),
      Expanded(
        child: RichText(
          text: TextSpan(
            style: DsTextStyle.bodyMedium.copyWith(color: DsColors.textPrimary),
            children: [
              TextSpan(
                text: title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(text: ' '),
              TextSpan(
                text: description,
                style: const TextStyle(color: DsColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

class _DetailedAnalysisSection extends StatelessWidget {
  const _DetailedAnalysisSection();

  @override
  Widget build(BuildContext context) => Column(
    spacing: DsSpacing.verticalSpace16,
    children: const [
      DsText.bodyMedium(
        data:
            'The analysis suggests that the current market saturation in Western territories necessitates a shift toward high-growth corridors. Digital transformation isn’t just an efficiency play; it’s a defensive measure against lean-tech competitors.',
      ),
      DsText.bodyMedium(
        data:
            'The report highlights that employee training programs must be updated to include AI-assisted workflows to maximize the ROI of new software implementations planned for the summer cycle.',
      ),
    ],
  );
}

class _SummaryActionBottomBar extends StatelessWidget {
  const _SummaryActionBottomBar();

  @override
  Widget build(BuildContext context) => Container(
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
          onTap: () {},
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
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        Row(
          spacing: 12,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: DsColors.backgroundDisabled,
                shape: BoxShape.circle,
              ),
            ),
            Container(
              width: 150,
              height: 24,
              color: DsColors.backgroundDisabled,
            ),
          ],
        ),
        Container(
          height: 100.h,
          decoration: BoxDecoration(
            color: DsColors.backgroundDisabled,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ],
    ),
  );
}
