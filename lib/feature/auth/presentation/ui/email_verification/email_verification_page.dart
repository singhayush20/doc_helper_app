import 'package:doc_helper_app/core/common/base_bloc/base_bloc.dart';
import 'package:doc_helper_app/core/common/base_widget/base_widget_utils.dart';
import 'package:doc_helper_app/core/common/constants/media_constants/image_keys.dart';
import 'package:doc_helper_app/core/common/utils/date_time_utils.dart';
import 'package:doc_helper_app/core/router/route_mapper.dart';
import 'package:doc_helper_app/design/design.dart'
    show
        DsSpacing,
        DsColors,
        DsText,
        DsButton,
        DsPinField,
        DsTextButton,
        DsTextStyle,
        DsImage,
        PrimaryAppBar;
import 'package:doc_helper_app/di/injection.dart';
import 'package:doc_helper_app/feature/auth/presentation/bloc/email_verification/email_verification_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';

part 'email_verification_form.dart';

class EmailVerificationPage extends StatelessWidget {
  const EmailVerificationPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<EmailVerificationBloc>(
    create: (_) => getIt<EmailVerificationBloc>()..started(),
    child: BlocConsumer<EmailVerificationBloc, EmailVerificationState>(
      listener: _handleState,
      builder: (context, state) => LoaderOverlay(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: PrimaryAppBar(
            titleText: 'Verify Email',
            backButtonRequired: false,
            actions: [
              DsTextButton.secondary(
                onTap: () =>
                    getBloc<EmailVerificationBloc>(context).onLogoutPressed(),
                data: 'Logout',
              ),
            ],
          ),
          body: const SafeArea(child: _EmailVerificationForm()),
        ),
      ),
    ),
  );

  void _handleState(BuildContext context, EmailVerificationState state) {
    if (state.store.loading) {
      context.loaderOverlay.show();
    } else {
      context.loaderOverlay.hide();
    }
    return switch (state) {
      OnOTPVerificationSuccess _ => context.goNamed(Routes.home),
      OnLogoutPress _ => context.goNamed(Routes.signIn),
      OnException(:final exception) => handleException(exception, context),
      _ => null,
    };
  }
}
