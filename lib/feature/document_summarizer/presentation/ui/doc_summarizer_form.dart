part of 'doc_summarizer_page.dart';

class _DocSummarizerForm extends StatelessWidget {
  const _DocSummarizerForm();

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Padding(
      padding: EdgeInsets.symmetric(
        vertical: DsSpacing.radialSpace24,
        horizontal: DsSpacing.radialSpace16,
      ),
      child: Column(
        spacing: DsSpacing.verticalSpace32,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _UploadArea(),
          const _RecentSummariesSection(),
        ],
      ),
    ),
  );
}

class _UploadArea extends StatelessWidget {
  const _UploadArea();

  @override
  Widget build(BuildContext context) => CustomPaint(
    painter: _DashedRectPainter(
      color: DsColors.primary.withAlpha(80),
      strokeWidth: 1.5,
      gap: 5,
    ),
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: DsColors.backgroundPrimary,
        borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius22),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: DsSpacing.radialSpace16,
          horizontal: DsSpacing.radialSpace8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            const _PreferencesSection(),
            DsSpacing.verticalSpaceSizedBox32,
            DecoratedBox(
              decoration: const BoxDecoration(
                color: DsColors.backgroundSubtle,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: EdgeInsets.all(DsSpacing.radialSpace16),
                child: Icon(
                  Icons.cloud_upload_rounded,
                  color: DsColors.primary,
                  size: DsSizing.size32,
                ),
              ),
            ),
            DsSpacing.verticalSpaceSizedBox24,
            // Header Text
            const DsText.titleLarge(
              data: 'Upload Document',
              color: DsColors.textPrimary,
              textAlign: TextAlign.center,
            ),
            DsSpacing.verticalSpaceSizedBox8,
            // Subtitle Text
            DsText.bodyMedium(
              data: '.pdf, .docx, or .txt (Max 5MB)',
              color: DsColors.textSecondary.withAlpha(180),
              textAlign: TextAlign.center,
            ),
            DsSpacing.verticalSpaceSizedBox32,
            DsButton.primary(
              data: 'Choose File',
              onTap: () {
                // TODO: Implement file picker logic
              },
            ),
          ],
        ),
      ),
    ),
  );
}

class _DashedRectPainter extends CustomPainter {
  _DashedRectPainter({
    required this.color,
    this.strokeWidth = 1.0,
    this.gap = 5.0,
  });

  final Color color;
  final double strokeWidth;
  final double gap;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final RRect rrect = RRect.fromLTRBR(
      0,
      0,
      size.width,
      size.height,
      Radius.circular(DsBorderRadius.borderRadius22),
    );

    final Path path = Path()..addRRect(rrect);

    final Path dashedPath = Path();
    for (final PathMetric metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        dashedPath.addPath(
          metric.extractPath(distance, distance + gap),
          Offset.zero,
        );
        distance += gap * 2;
      }
    }
    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PreferencesSection extends StatelessWidget {
  const _PreferencesSection();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: DsSpacing.verticalSpace24,
    children: [
      Row(
        children: [
          Icon(
            Icons.settings_rounded,
            color: DsColors.primary,
            size: DsSizing.size20,
          ),
          DsSpacing.horizontalSpaceSizedBox8,
          const DsText.titleLarge(
            data: 'Preferences',
            color: DsColors.textPrimary,
          ),
        ],
      ),
      const _PreferenceToggleGroup(
        label: 'SUMMARY TONE',
        options: ['Professional', 'Casual', 'Executive', 'Technical', 'Legal'],
        selectedIndex: 0,
      ),
      const _PreferenceToggleGroup(
        label: 'OUTPUT LENGTH',
        options: ['Short', 'Medium', 'Long', 'Very Long'],
        selectedIndex: 1,
      ),
    ],
  );
}

class _PreferenceToggleGroup extends StatelessWidget {
  const _PreferenceToggleGroup({
    required this.label,
    required this.options,
    required this.selectedIndex,
  });

  final String label;
  final List<String> options;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: DsSpacing.verticalSpace12,
    children: [
      DsText.labelMedium(data: label, color: DsColors.textTertiary),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(options.length, (index) {
            final isSelected = index == selectedIndex;
            return Padding(
              padding: EdgeInsets.only(right: DsSpacing.radialSpace12),
              child: _PreferenceChip(
                label: options[index],
                isSelected: isSelected,
                onTap: () {
                  // TODO: Implement state management for selection
                },
              ),
            );
          }),
        ),
      ),
    ],
  );
}

class _PreferenceChip extends StatelessWidget {
  const _PreferenceChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius12),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.symmetric(
        horizontal: DsSpacing.radialSpace20,
        vertical: DsSpacing.radialSpace12,
      ),
      decoration: BoxDecoration(
        color: isSelected ? DsColors.primary : DsColors.backgroundSurface,
        borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius12),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: DsColors.primary.withAlpha(40),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: DsText.titleSmall(
        data: label,
        color: isSelected ? DsColors.textOnDark : DsColors.textSecondary,
      ),
    ),
  );
}

class _RecentSummariesSection extends StatelessWidget {
  const _RecentSummariesSection();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: DsSpacing.verticalSpace16,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.history_rounded,
                color: DsColors.primary,
                size: DsSizing.size20,
              ),
              DsSpacing.horizontalSpaceSizedBox8,
              const DsText.titleLarge(
                data: 'Recent Summaries',
                color: DsColors.textPrimary,
              ),
            ],
          ),
          const DsText.titleSmall(data: 'View All', color: DsColors.primary),
        ],
      ),
      ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        separatorBuilder: (_, __) => DsSpacing.verticalSpaceSizedBox12,
        itemBuilder: (context, index) {
          final List<Map<String, dynamic>> mockData = [
            {
              'name': 'Project_Alpha_Spec.pdf',
              'date': 'Oct 24, 2023',
              'version': 'V3',
              'type': 'pdf',
            },
            {
              'name': 'Annual_Market_Analysis.do...',
              'date': 'Oct 22, 2023',
              'version': 'V1',
              'type': 'doc',
            },
            {
              'name': 'Meeting_Notes_Sales.txt',
              'date': 'Oct 21, 2023',
              'version': 'V2',
              'type': 'txt',
            },
          ];
          final item = mockData[index];

          return _SummaryCard(
            fileName: item['name'],
            date: item['date'],
            version: item['version'],
            fileType: item['type'],
          );
        },
      ),
    ],
  );
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.fileName,
    required this.date,
    required this.version,
    required this.fileType,
  });

  final String fileName;
  final String date;
  final String version;
  final String fileType;

  @override
  Widget build(BuildContext context) => DsListTile(
    onTap: () {},
    backgroundColor: DsColors.backgroundPrimary,
    borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius20),
    borderColor: DsColors.borderSubtle,
    borderWidth: DsBorderWidth.borderWidth1,
    leading: _FileIcon(fileType: fileType),
    title: ListTileTitleMedium(data: fileName),
    subtitle: ListTileSubTitleRich(
      richText: RichText(
        text: TextSpan(
          style: DsTextStyle.bodySmall.copyWith(color: DsColors.textSecondary),
          children: [
            TextSpan(text: date),
            const TextSpan(text: '  •  '),
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: _VersionBadge(version: version),
            ),
          ],
        ),
      ),
    ),
    trailing: Icon(
      Icons.chevron_right_rounded,
      color: DsColors.iconDisabled,
      size: DsSizing.size24,
    ),
  );
}

class _FileIcon extends StatelessWidget {
  const _FileIcon({required this.fileType});

  final String fileType;

  @override
  Widget build(BuildContext context) {
    final (bgColor, iconColor, icon) = switch (fileType) {
      'pdf' => (
        const Color(0xFFFFEBEE),
        const Color(0xFFD32F2F),
        Icons.picture_as_pdf_rounded,
      ),
      'doc' => (
        const Color(0xFFE3F2FD),
        const Color(0xFF1976D2),
        Icons.description_rounded,
      ),
      _ => (DsColors.backgroundSubtle, DsColors.primary, Icons.article_rounded),
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius12),
      ),
      child: Padding(
        padding: EdgeInsets.all(DsSpacing.radialSpace12),
        child: Icon(icon, color: iconColor, size: DsSizing.size24),
      ),
    );
  }
}

class _VersionBadge extends StatelessWidget {
  const _VersionBadge({required this.version});

  final String version;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: DsColors.backgroundSubtle,
      borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius4),
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: DsSpacing.radialSpace8,
        vertical: DsSpacing.radialSpace2,
      ),
      child: DsText.labelSmall(data: version, color: DsColors.primary),
    ),
  );
}
