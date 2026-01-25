import 'package:doc_helper_app/core/common/base_bloc/base_bloc.dart';
import 'package:doc_helper_app/core/common/constants/app_constants.dart';
import 'package:doc_helper_app/core/common/constants/media_constants/image_keys.dart';
import 'package:doc_helper_app/core/router/route_mapper.dart';
import 'package:doc_helper_app/core/value_objects/value_objects.dart';
import 'package:doc_helper_app/design/atoms/typography/ds_text.dart';
import 'package:doc_helper_app/design/design.dart'
    show DsColors, DsSpacing, PrimaryAppBar, DsListTile, DsImage;
import 'package:doc_helper_app/design/foundations/ds_border_radius.dart';
import 'package:doc_helper_app/design/foundations/ds_sizing.dart';
import 'package:doc_helper_app/design/molecules/list_tile/list_tile_title.dart';
import 'package:doc_helper_app/design/molecules/popup_menu_button/ds_menu_action.dart';
import 'package:doc_helper_app/design/molecules/popup_menu_button/ds_popup_menu.dart';
import 'package:doc_helper_app/design/molecules/text_form_field/ds_text_form_field.dart';
import 'package:doc_helper_app/di/injection.dart';
import 'package:doc_helper_app/feature/user_docs/domain/entities/user_doc_entity.dart';
import 'package:doc_helper_app/feature/user_docs/presentation/bloc/user_doc_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

part 'user_docs_form.dart';

class UserDocsPage extends StatelessWidget {
  const UserDocsPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<UserDocBloc>(
    create: (_) => getIt<UserDocBloc>()..started(),
    child: BlocConsumer<UserDocBloc, UserDocState>(
      listener: _handleState,
      builder: (context, state) => Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: const PrimaryAppBar(
          titleText: 'Documents',
          backButtonRequired: false,
        ),
        body: SafeArea(
          child: (state.store.loading)
              ? const Center(
                  child: CircularProgressIndicator(
                    color: DsColors.loadingIndicatorColorPrimary,
                  ),
                )
              : const _UserDocsForm(),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: DsColors.buttonPrimary,
          onPressed: () => getBloc<UserDocBloc>(context).onAddDocumentTapped(),
          child: const Icon(
            Icons.upload_file,
            color: DsColors.buttonPrimaryText,
          ),
        ),
      ),
    ),
  );

  void _handleState(BuildContext context, UserDocState state) =>
      switch (state) {
        OnAddDocumentTap _ => _onAddDocument(context: context),
        OnDocumentDeletionSuccess _ => getBloc<UserDocBloc>(
          context,
        ).onPageRefreshed(),
        OnDocumentTap(:final docId, :final documentName) => _onDocumentTap(
          context: context,
          documentName: documentName,
          docId: docId,
        ),
        _ => {},
      };

  Future<void> _onAddDocument({required BuildContext context}) async {
    final args = await context.pushNamed<Map<String, dynamic>>(
      Routes.docUpload,
    );
    final refreshRequired = args?[AppConstants.refreshRequired];
    if (context.mounted && (refreshRequired ?? false)) {
      getBloc<UserDocBloc>(context).onPageRefreshed();
    }
  }

  void _onDocumentTap({
    required BuildContext context,
    required String? documentName,
    required int? docId,
  }) {
    context.pushNamed(
      Routes.chat,
      queryParameters: {
        AppConstants.documentId: docId?.toString() ?? 0,
        AppConstants.documentName: documentName,
      },
    );
  }
}
