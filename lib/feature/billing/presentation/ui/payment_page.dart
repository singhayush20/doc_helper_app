import 'package:doc_helper_app/core/common/base_bloc/base_bloc.dart';
import 'package:doc_helper_app/core/common/base_widget/base_widget_utils.dart';
import 'package:doc_helper_app/core/common/constants/app_constants.dart';
import 'package:doc_helper_app/core/utils/enums.dart';
import 'package:doc_helper_app/core/utils/number_utils.dart';
import 'package:doc_helper_app/design/atoms/buttons/ds_button.dart';
import 'package:doc_helper_app/design/atoms/typography/ds_text.dart';
import 'package:doc_helper_app/design/foundations/ds_border_radius.dart';
import 'package:doc_helper_app/design/foundations/ds_border_width.dart';
import 'package:doc_helper_app/design/foundations/ds_colors.dart';
import 'package:doc_helper_app/design/foundations/ds_sizing.dart';
import 'package:doc_helper_app/design/foundations/ds_spacing.dart';
import 'package:doc_helper_app/design/widgets/ds_shimmer.dart';
import 'package:doc_helper_app/di/injection.dart';
import 'package:doc_helper_app/feature/billing/domain/entities/billing_entity.dart';
import 'package:doc_helper_app/feature/billing/presentation/bloc/payment_bloc.dart';
import 'package:doc_helper_app/feature/payment_gateway/domain/entities/payment_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        OnCheckoutCreate(:final store) => getBloc<PaymentBloc>(
          context,
        ).initiateTransaction(),
        OnPaymentSuccess(:final store, :final event) => _handlePaymentSuccess(
          event: event,
          store: store,
        ),
        OnPaymentFailure(:final store, :final event) => _handlePaymentFailure(
          event: event,
          store: store,
        ),
        OnExternalWalletEvent(:final store, :final event) =>
          _handleExternalWallet(event: event, store: store),
        _ => null,
      };

  void _handlePaymentSuccess({
    required PaymentGatewaySuccess event,
    required PaymentStateStore store,
  }) {
    print('## payment successful: $event');
  }

  void _handlePaymentFailure({
    required PaymentGatewayFailure event,
    required PaymentStateStore store,
  }) {
    print('## payment failure: $event');
  }

  void _handleExternalWallet({
    required PaymentGatewayExternalWallet event,
    required PaymentStateStore store,
  }) {
    print('## external wallet: $event');
  }
}
