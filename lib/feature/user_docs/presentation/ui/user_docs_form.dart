part of 'user_docs_page.dart';

class _UserDocsForm extends StatelessWidget {
  const _UserDocsForm();

  @override
  Widget build(BuildContext context) => BlocBuilder<UserDocBloc, UserDocState>(
    builder: (context, state) => Padding(
      padding: EdgeInsets.symmetric(horizontal: DsSpacing.radialSpace12),
      child: Column(
        children: [
          const UserDocsSearchBar(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async =>
                  getBloc<UserDocBloc>(context).onPageRefreshed(),
              child: PagedListView<int, UserDoc>.separated(
                state: (state.store.isSearchMode)
                    ? state.store.searchPagingState
                    : state.store.userDocsPagingState,
                shrinkWrap: true,
                fetchNextPage: () =>
                    getBloc<UserDocBloc>(context).fetchNextPage(),
                separatorBuilder: (context, index) => const Divider(),
                builderDelegate: PagedChildBuilderDelegate<UserDoc>(
                  itemBuilder: (context, item, index) =>
                      _DocumentItem(userDoc: item),
                  firstPageErrorIndicatorBuilder: (_) =>
                      const _FirstPageErrorWidget(),
                  noItemsFoundIndicatorBuilder: (_) =>
                      const _NoItemFoundBuilder(),
                  firstPageProgressIndicatorBuilder: (_) =>
                      const _FirstPageShimmer(),
                  newPageErrorIndicatorBuilder: (_) =>
                      const _NewPageErrorIndicator(),
                  newPageProgressIndicatorBuilder: (_) =>
                      const _NewPageProgressIndicator(),
                  noMoreItemsIndicatorBuilder: (_) =>
                      const _NoMoreItemsIndicator(),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _DocumentItem extends StatelessWidget {
  const _DocumentItem({required this.userDoc});

  final UserDoc? userDoc;

  @override
  Widget build(BuildContext context) {
    if (userDoc == null) {
      return const SizedBox.shrink();
    }
    return DsListTile(
      leading: DecoratedBox(
        decoration: BoxDecoration(
          color: DsColors.backgroundSubtle,
          borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius12),
        ),
        child: Padding(
          padding: EdgeInsets.all(DsSpacing.radialSpace8),
          child: Icon(
            Icons.article_outlined,
            color: DsColors.primary,
            size: 24.r,
          ),
        ),
      ),
      title: ListTileTitleMedium(
        data: userDoc!.originalFilename ?? 'Unnamed Document',
      ),
      trailing: _StatusBadge(status: userDoc?.status),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({this.status});

  final DocumentStatus? status;

  @override
  Widget build(BuildContext context) {
    final (:backgroundColor, :textColor) = _getBadgeStyle(status);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(
          DsBorderRadius.borderRadius20,
        ), // Pill shape
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: DsSpacing.horizontalSpace12,
          vertical: DsSpacing.verticalSpace4,
        ),
        child: DsText.labelMedium(
          data: _formatStatusText(status),
          color: textColor,
        ),
      ),
    );
  }

  ({Color backgroundColor, Color textColor}) _getBadgeStyle(
    DocumentStatus? status,
  ) {
    switch (status) {
      case DocumentStatus.ready:
        return (
          backgroundColor: DsColors.success.withAlpha(25),
          textColor: DsColors.textSuccess,
        );
      case DocumentStatus.failed:
        return (
          backgroundColor: DsColors.error.withAlpha(25),
          textColor: DsColors.textError,
        );
      case DocumentStatus.processing:
      case DocumentStatus.uploaded:
        return (
          backgroundColor: DsColors.backgroundInfo,
          textColor: DsColors.textAccent,
        );
      default:
        return (
          backgroundColor: DsColors.backgroundDisabled,
          textColor: DsColors.textSecondary,
        );
    }
  }

  String _formatStatusText(DocumentStatus? status) {
    if (status == null) return 'Unknown';
    final name = status.name;
    return name[0].toUpperCase() + name.substring(1);
  }
}

class _NoItemFoundBuilder extends StatelessWidget {
  const _NoItemFoundBuilder();

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius12),
      color: DsColors.backgroundPrimary,
    ),
    child: Column(
      spacing: DsSpacing.verticalSpace8,
      mainAxisSize: MainAxisSize.min,
      children: [
        const DsImage(mediaUrl: ImageKeys.noDataIllustration),
        const DsText.titleLarge(data: 'No documents found'),
      ],
    ),
  );
}

class _FirstPageErrorWidget extends StatelessWidget {
  const _FirstPageErrorWidget();

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius12),
      color: DsColors.backgroundPrimary,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      spacing: DsSpacing.verticalSpace8,
      children: [
        const DsImage(mediaUrl: ImageKeys.docFetchErrorIllustration),
        const DsText.titleLarge(data: 'Failed to fetch documents'),
        InkWell(
          onTap: () => getBloc<UserDocBloc>(context).fetchNextPage(),
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: DsSpacing.verticalSpace12,
              horizontal: DsSpacing.horizontalSpace32,
            ),
            decoration: BoxDecoration(
              color: DsColors.buttonPrimary,
              borderRadius: BorderRadius.circular(
                DsBorderRadius.borderRadius12,
              ),
            ),
            child: const DsText.labelLarge(
              data: 'Retry',
              color: DsColors.buttonPrimaryText,
            ),
          ),
        ),
      ],
    ),
  );
}

class _FirstPageShimmer extends StatelessWidget {
  const _FirstPageShimmer();

  @override
  Widget build(BuildContext context) => Shimmer(
    duration: const Duration(seconds: 3),
    interval: const Duration(seconds: 1),
    color: DsColors.backgroundPrimary,
    colorOpacity: 0.3,
    enabled: true,
    direction: const ShimmerDirection.fromLTRB(),
    child: Column(
      children: List.generate(8, (index) => const _ShimmerListTile()),
    ),
  );
}

class _ShimmerListTile extends StatelessWidget {
  const _ShimmerListTile();

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(
      vertical: DsSpacing.verticalSpace8,
      horizontal: DsSpacing.horizontalSpace4,
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 48.h,
          width: 48.w,
          decoration: BoxDecoration(
            color: DsColors.backgroundDisabled,
            // Using DsBorderRadius
            borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius8),
          ),
        ),
        DsSpacing.horizontalSpaceSizedBox12,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 16.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: DsColors.backgroundDisabled,
                  // Using DsBorderRadius
                  borderRadius: BorderRadius.circular(
                    DsBorderRadius.borderRadius4,
                  ),
                ),
              ),
              DsSpacing.verticalSpaceSizedBox8,
              Container(
                height: 12.h,
                width: 200.w,
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
      ],
    ),
  );
}

class _NewPageProgressIndicator extends StatelessWidget {
  const _NewPageProgressIndicator();

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(vertical: DsSpacing.verticalSpace16),
    child: const Center(
      child: CircularProgressIndicator(
        color: DsColors.loadingIndicatorColorPrimary,
      ),
    ),
  );
}

class _NewPageErrorIndicator extends StatelessWidget {
  const _NewPageErrorIndicator();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<UserDocBloc>();
    return InkWell(
      onTap: () => bloc.fetchNextPage(),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: DsSpacing.verticalSpace24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: DsSpacing.verticalSpace4,
          children: [
            const DsText.bodyMedium(
              data: 'Failed to load more documents',
              color: DsColors.textError,
            ),
            const DsText.labelLarge(
              data: 'Tap to retry',
              color: DsColors.textLink,
              underline: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _NoMoreItemsIndicator extends StatelessWidget {
  const _NoMoreItemsIndicator();

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(vertical: DsSpacing.verticalSpace24),
    child: const Center(
      child: DsText.bodySmall(
        data: "You've reached the end of the list.",
        color: DsColors.textTertiary,
      ),
    ),
  );
}

class UserDocsSearchBar extends StatefulWidget {
  const UserDocsSearchBar({super.key});

  @override
  State<UserDocsSearchBar> createState() => _UserDocsSearchBarState();
}

class _UserDocsSearchBarState extends State<UserDocsSearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<UserDocBloc, UserDocState>(
    builder: (context, state) => Padding(
      padding: EdgeInsets.symmetric(vertical: DsSpacing.verticalSpace12),
      child: SearchQueryTextFormField(
        value: SearchQuery(state.store.searchQuery),
        controller: _controller,
        hintText: 'Search Documents...',
        prefixIcon: Icons.search,
        suffixIconWidget: state.store.searchQuery.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _controller.clear();
                  getBloc<UserDocBloc>(context).searchQueryChanged('');
                },
              )
            : null,
        onChanged: (value) =>
            getBloc<UserDocBloc>(context).searchQueryChanged(value),
      ),
    ),
  );
}
