import 'package:doc_helper_app/core/common/base_bloc/base_bloc.dart';
import 'package:doc_helper_app/core/common/base_widget/base_widget_utils.dart';
import 'package:doc_helper_app/core/common/constants/media_constants/image_keys.dart';
import 'package:doc_helper_app/core/common/utils/date_time_utils.dart';
import 'package:doc_helper_app/core/router/route_mapper.dart';
import 'package:doc_helper_app/design/atoms/buttons/ds_button.dart';
import 'package:doc_helper_app/design/atoms/text_button/ds_text_button.dart';
import 'package:doc_helper_app/design/atoms/typography/ds_text.dart';
import 'package:doc_helper_app/design/atoms/typography/ds_text_style.dart';
import 'package:doc_helper_app/design/foundations/ds_colors.dart';
import 'package:doc_helper_app/design/foundations/ds_spacing.dart';
import 'package:doc_helper_app/design/molecules/app_bar/primary_app_bar.dart';
import 'package:doc_helper_app/design/molecules/pin_field/ds_pin_field.dart';
import 'package:doc_helper_app/design/molecules/text_form_field/ds_text_form_field.dart';
import 'package:doc_helper_app/design/widgets/ds_image.dart';
import 'package:doc_helper_app/di/injection.dart';
import 'package:doc_helper_app/feature/auth/presentation/bloc/signup/signup_bloc.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';

part 'signup_form.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<SignUpBloc>(
    create: (_) => getIt<SignUpBloc>()..started(),
    child: BlocConsumer<SignUpBloc, SignUpState>(
      listener: _handleState,
      builder: (context, state) => const LoaderOverlay(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: PrimaryAppBar(titleText: 'Sign Up'),
          body: SafeArea(child: _SignUpForm()),
        ),
      ),
    ),
  );

  void _handleState(BuildContext context, SignUpState state) {
    if (state.store.loading) {
      context.loaderOverlay.show();
    } else {
      context.loaderOverlay.hide();
    }
    return switch (state) {
      OnSignInPress _ => GoRouter.of(context).pop(),
      OnAccountCreate _ => getBloc<SignUpBloc>(context).onTimerStarted(),
      OnOTPVerificationSuccess _ => context.goNamed(Routes.home),
      OnException(:final exception) => handleException(exception, context),
      _ => null,
    };
  }
}
