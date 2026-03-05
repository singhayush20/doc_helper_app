part of 'summary_history_page.dart';

class _SummaryHistoryForm extends StatelessWidget {
  const _SummaryHistoryForm();

  @override
  Widget build(BuildContext context) => RefreshIndicator(
    onRefresh: () async => getBloc<HistoryBloc>(context).onPageRefreshed(),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: DsSpacing.radialSpace16),
      child: Column(
        children: [
          const _HistorySearchBar(),
          Expanded(
            child: BlocBuilder<HistoryBloc, HistoryState>(
              builder: (context, state) => DsShimmer(
                enabled: state.store.loading,
                child: Visibility(
                  visible: !state.store.loading,
                  replacement: const _HistoryShimmer(),
                  child: state.store.filteredDocuments?.isEmpty ?? true
                      ? const _NoHistoryFound()
                      : ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: state.store.filteredDocuments?.length ?? 1,
                          separatorBuilder: (_, _) =>
                              DsSpacing.verticalSpaceSizedBox12,
                          itemBuilder: (context, index) {
                            final doc = state.store.filteredDocuments?[index];

                            return _HistoryCard(
                              documentId: doc?.documentId,
                              fileName: doc?.originalFilename ?? 'Unknown',
                              date: getTimeAgo(doc?.createdAt),
                              fileType: getFileType(fileName: doc?.fileName),
                            );
                          },
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({
    required this.documentId,
    required this.fileName,
    required this.date,
    required this.fileType,
  });

  final int? documentId;
  final String fileName;
  final String date;
  final FileType fileType;

  @override
  Widget build(BuildContext context) => DsListTile(
    onTap: () =>
        getBloc<HistoryBloc>(context).onDocumentPressed(documentId: documentId),
    backgroundColor: DsColors.backgroundPrimary,
    borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius16),
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
    trailing:  IconButton(
      onPressed: () => getBloc<HistoryBloc>(
        context,
      ).onDocumentDeleted(documentId: documentId),
      icon: Icon(
        Icons.delete_outline_rounded,
        color: DsColors.iconSecondary,
        size: DsSizing.size20,
      ),
    ),
  );
}

class _HistorySearchBar extends StatefulWidget {
  const _HistorySearchBar();

  @override
  State<_HistorySearchBar> createState() => _HistorySearchBarState();
}

class _HistorySearchBarState extends State<_HistorySearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<HistoryBloc, HistoryState>(
    builder: (context, state) => Padding(
      padding: EdgeInsets.symmetric(vertical: DsSpacing.verticalSpace16),
      child: SearchQueryTextFormField(
        value: SearchQuery(state.store.searchQuery),
        controller: _controller,
        hintText: 'Search summaries by name or content...',
        prefixIcon: Icons.search,
        suffixIconWidget: state.store.searchQuery.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _controller.clear();
                  getBloc<HistoryBloc>(context).searchQueryChanged('');
                },
              )
            : null,
        onChanged: (value) =>
            getBloc<HistoryBloc>(context).searchQueryChanged(value),
      ),
    ),
  );
}

class _NoHistoryFound extends StatelessWidget {
  const _NoHistoryFound();

  @override
  Widget build(BuildContext context) => const Center(
    child: DsText.bodyMedium(
      data: 'Nothing to show',
      color: DsColors.textSecondary,
    ),
  );
}

class _HistoryShimmer extends StatelessWidget {
  const _HistoryShimmer();

  @override
  Widget build(BuildContext context) => ListView.separated(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: 6,
    separatorBuilder: (_, _) => DsSpacing.verticalSpaceSizedBox12,
    itemBuilder: (_, _) => Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: DsColors.backgroundDisabled,
        borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius16),
      ),
    ),
  );
}
