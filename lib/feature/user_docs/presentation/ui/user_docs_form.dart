part of 'user_docs_page.dart';

class _UserDocsForm extends StatelessWidget {
  const _UserDocsForm();

  @override
  Widget build(BuildContext context) => BlocBuilder<UserDocBloc,UserDocState>(
    builder: (context, state) => Padding(
      padding: EdgeInsets.symmetric(
        vertical: DsSpacing.radialSpace20,
        horizontal: DsSpacing.radialSpace12,
      ),
      child: Column(
        children: [
        ]
      ),
    ),
  );
}
