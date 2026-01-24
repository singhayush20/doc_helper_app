import 'package:doc_helper_app/core/common/base_bloc/base_bloc.dart';
import 'package:doc_helper_app/core/common/base_widget/base_widget_utils.dart';
import 'package:doc_helper_app/core/common/constants/app_constants.dart';
import 'package:doc_helper_app/core/common/utils/date_time_utils.dart';
import 'package:doc_helper_app/core/extensions/extensions.dart';
import 'package:doc_helper_app/core/router/route_mapper.dart';
import 'package:doc_helper_app/core/utils/enums.dart';
import 'package:doc_helper_app/core/utils/number_utils.dart';
import 'package:doc_helper_app/design/atoms/typography/ds_text_style.dart';
import 'package:doc_helper_app/design/design.dart'
    show DsText, DsButton, DsColors, DsSpacing, DsBorderRadius, DsSizing;
import 'package:doc_helper_app/design/molecules/app_bar/primary_app_bar.dart';
import 'package:doc_helper_app/design/molecules/list_tile/ds_list_tile.dart';
import 'package:doc_helper_app/design/molecules/list_tile/list_tile_title.dart';
import 'package:doc_helper_app/di/injection.dart';
import 'package:doc_helper_app/feature/profile/presentation/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

part 'profile_form.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<ProfileBloc>(
    create: (_) => getIt<ProfileBloc>()..started(),
    child: Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: DsColors.backgroundSurface,
      appBar: const PrimaryAppBar(
        titleText: 'My account',
        backButtonRequired: false,
      ),
      body: SafeArea(
        child: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) => switch (state) {
            OnLogout _ => GoRouter.of(context).goNamed(Routes.signIn),
            OnResetPasswordPress _ => GoRouter.of(context).pushNamed(
              Routes.passwordReset,
              queryParameters: {AppConstants.parentRoute: Routes.profile},
            ),
            OnManageSubscriptionTap _ => _handleManageSubscription(context),
            OnException(:final exception) => handleException(
              exception,
              context,
            ),
            _ => null,
          },
          builder: (context, state) => (!state.store.loading)
              ? const _ProfileForm()
              : const Center(
                  child: CircularProgressIndicator(
                    color: DsColors.loadingIndicatorColorPrimary,
                  ),
                ),
        ),
      ),
    ),
  );

  void _handleManageSubscription(BuildContext context) async {
    final args = await GoRouter.of(
      context,
    ).pushNamed<Map<String, dynamic>>(Routes.plans);

    if (context.mounted && (args?[AppConstants.refreshRequired] ?? false)) {
      getBloc<ProfileBloc>(context).started();
    }
  }
}
