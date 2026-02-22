part of 'doc_summarizer_page.dart';

class _DocSummarizerForm extends StatelessWidget {
  const _DocSummarizerForm();

  @override
  Widget build(BuildContext context) => RefreshIndicator(
    onRefresh: () async => getBloc<DocSummarizerBloc>(context).started(),
    child: SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: DsSpacing.radialSpace24,
          horizontal: DsSpacing.radialSpace16,
        ),
        child: Column(
          spacing: DsSpacing.verticalSpace32,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [const _UploadArea(), const _RecentSummariesSection()],
        ),
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
        child: BlocBuilder<DocSummarizerBloc, DocSummarizerState>(
          builder: (context, state) {
            final isUploading = state.store.uploading;
            final validationError = state.store.validationErrorMessage;

            return Column(
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
                // Subtitle or Progress Text
                DsText.bodyMedium(
                  data: isUploading
                      ? state.store.uploadProgressMessage ??
                            'Upload in progress...'
                      : '.pdf, .docx or .txt (Max 5MB)',
                  color: isUploading
                      ? DsColors.textAccent
                      : DsColors.textSecondary.withAlpha(180),
                  textAlign: TextAlign.center,
                ),

                if (validationError != null) ...[
                  DsSpacing.verticalSpaceSizedBox8,
                  DsText.bodySmall(
                    data: validationError,
                    color: DsColors.error,
                    textAlign: TextAlign.center,
                  ),
                ],

                DsSpacing.verticalSpaceSizedBox32,
                DsButton.primary(
                  data: 'Choose File',
                  onTap: isUploading
                      ? null
                      : () => getBloc<DocSummarizerBloc>(
                          context,
                        ).add(const DocSummarizerEvent.uploadDocument()),
                ),
              ],
            );
          },
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
  Widget build(BuildContext context) {
    final bloc = getBloc<DocSummarizerBloc>(context);

    return BlocBuilder<DocSummarizerBloc, DocSummarizerState>(
      builder: (context, state) => Column(
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
          PreferenceToggleGroup<SummaryTone>(
            label: 'SUMMARY TONE',
            options: SummaryTone.values,
            selectedOption: state.store.selectedTone,
            onSelected: (tone) => bloc.onSummaryToneChanged(tone),
          ),
          PreferenceToggleGroup<SummaryLength>(
            label: 'OUTPUT LENGTH',
            options: SummaryLength.values,
            selectedOption: state.store.selectedLength,
            onSelected: (length) => bloc.onSummaryLengthChanged(length),
          ),
        ],
      ),
    );
  }
}

class _RecentSummariesSection extends StatelessWidget {
  const _RecentSummariesSection();

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<DocSummarizerBloc, DocSummarizerState>(
        builder: (context, state) {
          final documents = state.store.documentsInfo?.documents ?? [];

          return DsShimmer(
            enabled: state.store.loading,
            child: Visibility(
              visible: !state.store.loading,
              replacement: const _RecentSummariesShimmer(),
              child: Column(
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
                      DsTextButton.primary(
                        data: 'View All',
                        onTap: () => getBloc<DocSummarizerBloc>(
                          context,
                        ).onViewAllPressed(),
                      ),
                    ],
                  ),
                  if (documents.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: DsText.bodyMedium(
                          data: 'No recent summaries found.',
                          color: DsColors.textSecondary,
                        ),
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: documents.length <= 3 ? documents.length : 3,
                      separatorBuilder: (_, _) =>
                          DsSpacing.verticalSpaceSizedBox12,
                      itemBuilder: (context, index) {
                        final doc = documents[index];
                        return _SummaryCard(
                          id: doc.documentId,
                          fileName: doc.originalFilename ?? 'Unknown',
                          fileType: getFileType(fileName: doc.fileName),
                          date: getTimeAgo(doc.createdAt),
                        );
                      },
                    ),
                ],
              ),
            ),
          );
        },
      );
}

class _RecentSummariesShimmer extends StatelessWidget {
  const _RecentSummariesShimmer();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: DsSpacing.verticalSpace16,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 24.h,
            width: 150.w,
            decoration: BoxDecoration(
              color: DsColors.backgroundDisabled,
              borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius4),
            ),
          ),
          Container(
            height: 16.h,
            width: 60.w,
            decoration: BoxDecoration(
              color: DsColors.backgroundDisabled,
              borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius4),
            ),
          ),
        ],
      ),
      ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        separatorBuilder: (_, _) => DsSpacing.verticalSpaceSizedBox12,
        itemBuilder: (_, _) => Container(
          height: 80.h,
          decoration: BoxDecoration(
            color: DsColors.backgroundDisabled,
            borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius20),
          ),
        ),
      ),
    ],
  );
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.id,
    required this.fileName,
    required this.date,
    required this.fileType,
  });

  final int? id;
  final String fileName;
  final String date;
  final FileType fileType;

  @override
  Widget build(BuildContext context) => DsListTile(
    onTap: () =>
        getBloc<DocSummarizerBloc>(context).onDocumentPressed(documentId: id),
    backgroundColor: DsColors.backgroundPrimary,
    borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius20),
    borderColor: DsColors.borderSubtle,
    borderWidth: DsBorderWidth.borderWidth1,
    leading: FileIcon(fileType: fileType),
    title: ListTileTitleMedium(data: fileName),
    subtitle: ListTileSubTitleRich(
      richText: RichText(
        text: TextSpan(
          style: DsTextStyle.bodySmall.copyWith(color: DsColors.textSecondary),
          children: [TextSpan(text: date)],
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
