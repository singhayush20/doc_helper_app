import 'package:doc_helper_app/core/common/base_widget/base_widget_utils.dart';
import 'package:doc_helper_app/design/design.dart';
import 'package:doc_helper_app/di/injection.dart';
import 'package:doc_helper_app/feature/billing/domain/entities/billing_entity.dart';
import 'package:doc_helper_app/feature/plan/presentation/bloc/plans_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part 'plans_form.dart';

class PlansPage extends StatelessWidget {
  const PlansPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) => getIt<PlansBloc>()..started(),
    child: BlocConsumer<PlansBloc, PlansState>(
      builder: (context, state) => const Scaffold(
        appBar: PrimaryAppBar(titleText: 'Plans'),
        body: _PlansForm(),
      ),
      listener: _handleState,
    ),
  );

  void _handleState(BuildContext context, PlansState state) => switch (state) {
    OnException(:final exception) => handleException(exception, context),
    _ => null,
  };
}
