import 'dart:async';

import 'package:dio/dio.dart';
import 'package:doc_helper_app/common/base_bloc/base_bloc.dart';
import 'package:doc_helper_app/common/constants/media_constants/image_keys.dart';
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
import 'package:doc_helper_app/network/sse/sse_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part 'signin_form.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<SignInBloc>(
    create: (_) => getIt<SignInBloc>()..started(),
    child: Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: DsColors.backgroundPrimary,
      body: SafeArea(
        child: BlocConsumer<SignInBloc, SignInState>(
          listener: (context, state) {},
          builder: (context, state) => _SignInForm(),
        ),
      ),
    ),
  );
}
