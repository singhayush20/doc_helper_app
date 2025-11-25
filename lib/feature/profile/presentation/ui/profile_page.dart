import 'package:doc_helper_app/core/common/base_bloc/base_bloc.dart';
import 'package:doc_helper_app/core/common/base_widget/base_widget_utils.dart';
import 'package:doc_helper_app/core/common/constants/app_constants.dart';
import 'package:doc_helper_app/core/router/route_mapper.dart';
import 'package:doc_helper_app/design/atoms/typography/ds_text_style.dart';
import 'package:doc_helper_app/design/design.dart'
    show DsText, DsButton, DsColors, DsSpacing, DsBorderRadius, DsSizing;
import 'package:doc_helper_app/design/molecules/list_tile/ds_list_tile.dart';
import 'package:doc_helper_app/design/molecules/list_tile/list_tile_title.dart';
import 'package:doc_helper_app/di/injection.dart';
import 'package:doc_helper_app/feature/plan/domain/enum/plan_info_enum.dart';
import 'package:doc_helper_app/feature/profile/presentation/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';

part 'profile_form.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<ProfileBloc>(
    create: (_) => getIt<ProfileBloc>()..started(),
    child: LoaderOverlay(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: DsColors.backgroundSurface,
        body: SafeArea(
          child: BlocConsumer<ProfileBloc, ProfileState>(
            listener: (context, state) {
              if (state.store.loading) {
                context.loaderOverlay.show();
              } else {
                context.loaderOverlay.hide();
              }
              return switch (state) {
                OnLogout _ => GoRouter.of(context).goNamed(Routes.signIn),
                OnResetPasswordPress _ => GoRouter.of(context).pushNamed(
                  Routes.passwordReset,
                  queryParameters: {AppConstants.parentRoute: Routes.profile},
                ),
                OnException(:final exception) => handleException(
                  exception,
                  context,
                ),
                _ => null,
              };
            },
            builder: (context, state) => (!state.store.loading)
                ? const _ProfileForm()
                : const SizedBox(),
          ),
        ),
      ),
    ),
  );
}
