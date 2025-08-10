import 'package:doc_helper_app/design/design.dart';
import 'package:doc_helper_app/di/injection.dart';
import 'package:doc_helper_app/feature/splash_screen/presentation/bloc/splash_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'splash_form.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<SplashBloc>(
    create: (_) => getIt<SplashBloc>()..started(),
    child: Scaffold(
      backgroundColor: DsColors.primary,
      body: BlocListener<SplashBloc, SplashState>(
        listener: _handleState,
        child: const _SplashForm(),
      ),
    ),
  );

  void _handleState(BuildContext context, SplashState state) => switch (state) {
    OnCurrentUserFetch _ => {},
    _ => {},
  };
}
