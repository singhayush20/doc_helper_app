import 'package:doc_helper_app/di/injection.dart';
import 'package:doc_helper_app/feature/signin/presentation/bloc/signin_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'signin_form.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<SignInBloc>(
    create: (_) => getIt<SignInBloc>()..started(),
    child: Scaffold(
      body: BlocConsumer<SignInBloc, SignInState>(
        listener: (context, state) {},
        builder: (context, state) => const _SignInForm(),
      ),
    ),
  );
}
