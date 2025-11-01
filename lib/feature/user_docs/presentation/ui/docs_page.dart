import 'package:doc_helper_app/design/design.dart' show DsColors;
import 'package:doc_helper_app/di/injection.dart';
import 'package:doc_helper_app/feature/user_docs/presentation/bloc/user_doc_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'docs_form.dart';

class UserDocsPage extends StatelessWidget {
  const UserDocsPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<UserDocBloc>(
    create: (_) => getIt<UserDocBloc>()..started(),
    child: const Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: DsColors.backgroundSurface,
      body: SafeArea(child: _UserDocsForm()),
    ),
  );
}
