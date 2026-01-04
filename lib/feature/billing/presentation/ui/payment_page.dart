import 'package:doc_helper_app/core/common/base_widget/base_widget_utils.dart';
import 'package:doc_helper_app/core/common/constants/app_constants.dart';
import 'package:doc_helper_app/design/widgets/ds_shimmer.dart';
import 'package:doc_helper_app/di/injection.dart';
import 'package:doc_helper_app/feature/billing/domain/entities/billing_entity.dart';
import 'package:doc_helper_app/feature/billing/presentation/bloc/payment_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

part 'payment_form.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<PaymentBloc>(
    create: (_) {
      final product = GoRouterState.of(context).extra as BillingProductInfo;
      return getIt<PaymentBloc>()
        ..started(args: {AppConstants.product: product});
    },
    child: BlocConsumer<PaymentBloc, PaymentState>(
      builder: (context, state) => Scaffold(
        appBar: AppBar(title: const Text('Checkout')),
        body: const _PaymentForm(),
      ),
      listener: _handleState,
    ),
  );

  void _handleState(BuildContext context, PaymentState state) =>
      switch (state) {
        OnException(:final exception) => handleException(exception, context),
        _ => null,
      };
}
