import 'package:doc_helper_app/di/injection.dart';
import 'package:doc_helper_app/feature/auth/presentation/bloc/signup/signup_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          body: SafeArea(child: _SignUpForm()),
        ),
      ),
    ),
  );

  void _handleState(BuildContext context, SignUpState state) {}
}
