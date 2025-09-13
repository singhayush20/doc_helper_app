import 'package:doc_helper_app/common/base_bloc/base_bloc.dart';
import 'package:doc_helper_app/common/base_widget/base_widget_utils.dart';
import 'package:doc_helper_app/common/constants/media_constants/image_keys.dart';
import 'package:doc_helper_app/core/router/route_mapper.dart';
import 'package:doc_helper_app/core/value_objects/value_objects.dart';
import 'package:doc_helper_app/design/design.dart'
    show
        DsSpacing,
        DsText,
        DsColors,
        DsBorderRadius,
        EmailTextFormField,
        PasswordTextFormField,
        DsButton,
        DsTextButton,
        DsImage;
import 'package:doc_helper_app/design/foundations/ds_border_width.dart';
import 'package:doc_helper_app/di/injection.dart';
import 'package:doc_helper_app/feature/auth/presentation/bloc/signin_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';

part 'signin_form.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<SignInBloc>(
    create: (_) => getIt<SignInBloc>()..started(),
    child: LoaderOverlay(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: DsColors.backgroundPrimary,
        body: SafeArea(
          child: BlocConsumer<SignInBloc, SignInState>(
            listener: (context, state) {
              if (state.store.loading) {
                context.loaderOverlay.show();
              } else {
                context.loaderOverlay.hide();
              }
              return switch (state) {
                OnSignUpPressed _ => GoRouter.of(
                  context,
                ).pushNamed(Routes.signUp),
                OnForgotPasswordPressed _ => GoRouter.of(
                  context,
                ).pushNamed(Routes.passwordReset),
                OnException(:final exception) => handleException(
                  exception,
                  context,
                ),
                _ => null,
              };
            },
            builder: (context, state) => const _SignInForm(),
          ),
        ),
      ),
    ),
  );
}
