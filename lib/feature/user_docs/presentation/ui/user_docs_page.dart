import 'package:doc_helper_app/core/common/base_bloc/base_bloc.dart';
import 'package:doc_helper_app/design/design.dart'
    show DsColors, DsSpacing, PrimaryAppBar, DsListTile;
import 'package:doc_helper_app/design/molecules/list_tile/list_tile_subtitle.dart';
import 'package:doc_helper_app/design/molecules/list_tile/list_tile_title.dart';
import 'package:doc_helper_app/di/injection.dart';
import 'package:doc_helper_app/feature/user_docs/domain/entities/user_doc_entity.dart';
import 'package:doc_helper_app/feature/user_docs/presentation/bloc/user_doc_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

part 'user_docs_form.dart';

class UserDocsPage extends StatelessWidget {
  const UserDocsPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<UserDocBloc>(
        create: (_) => getIt<UserDocBloc>()..started(),
        child: const Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: DsColors.backgroundSurface,
          appBar: PrimaryAppBar(
            titleText: 'Documents',
            backButtonRequired: false,
          ),
          body: SafeArea(child: _UserDocsForm()),
        ),
      );
}
