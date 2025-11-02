part of 'user_docs_page.dart';

class _UserDocsForm extends StatelessWidget {
  const _UserDocsForm();

  @override
  Widget build(BuildContext context) => BlocBuilder<UserDocBloc, UserDocState>(
    builder: (context, state) => Padding(
      padding: EdgeInsets.symmetric(
        vertical: DsSpacing.radialSpace20,
        horizontal: DsSpacing.radialSpace12,
      ),
      child: PagedListView<int, UserDoc>(
        shrinkWrap: true,
        state: state.store.userDocsPagingState,
        fetchNextPage: getBloc<UserDocBloc>(context).fetchNextPage,
        builderDelegate: PagedChildBuilderDelegate(
          itemBuilder: (context, item, index) => DsListTile(
            title: ListTileTitleMedium(data: item.originalFilename ?? ''),
            subtitle: ListTileSubtitleMedium(
              data: item.status?.name.toUpperCase() ?? '',
            ),
          ),
        ),
      ),
    ),
  );
}
