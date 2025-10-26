import 'package:doc_helper_app/core/common/base_bloc/base_bloc.dart';
import 'package:doc_helper_app/core/common/base_widget/base_widget_utils.dart';
import 'package:doc_helper_app/core/common/constants/media_constants/image_keys.dart';
import 'package:doc_helper_app/core/common/utils/date_time_utils.dart';
import 'package:doc_helper_app/core/value_objects/value_objects.dart';
import 'package:doc_helper_app/design/atoms/typography/ds_text_style.dart';
import 'package:doc_helper_app/design/design.dart'
    show
        PrimaryAppBar,
        DsSpacing,
        DsText,
        DsColors,
        DsButton,
        EmailTextFormField,
        DsTextButton,
        DsPinField,
        PasswordTextFormField;
import 'package:doc_helper_app/design/molecules/snackbar/ds_snackbar.dart';
import 'package:doc_helper_app/design/widgets/ds_image.dart';
import 'package:doc_helper_app/di/injection.dart';
import 'package:doc_helper_app/feature/auth/presentation/bloc/password_reset/password_reset_bloc.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';

part 'password_reset_form.dart';

class PasswordResetPage extends StatelessWidget {
  const PasswordResetPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<PasswordResetBloc>(
    create: (_) => getIt<PasswordResetBloc>()..started(),
    child: LoaderOverlay(
      child: Scaffold(
        appBar: const PrimaryAppBar(titleText: 'Reset Password'),
        body: SafeArea(
          child: BlocConsumer<PasswordResetBloc, PasswordResetState>(
            listener: _handleState,
            builder: (context, state) => const _PasswordResetForm(),
          ),
        ),
      ),
    ),
  );

  void _handleState(BuildContext context, PasswordResetState state) {
    if (state.store.loading) {
      context.loaderOverlay.show();
    } else {
      context.loaderOverlay.hide();
    }

    return switch (state) {
      OnPasswordSaved _ => _handlePasswordResetSuccess(context: context),
      OnException(:final exception) => handleException(exception, context),
      _ => null,
    };
  }

  void _handlePasswordResetSuccess({required BuildContext context}) {
    showSnackBar(
      context: context,
      message: 'Password Reset Successful!',
      type: SnackbarMessageType.success,
    );
    GoRouter.of(context).pop();
  }
}
