import 'package:doc_helper_app/core/common/base_bloc/base_bloc.dart';
import 'package:doc_helper_app/core/common/base_widget/base_widget_utils.dart';
import 'package:doc_helper_app/core/common/constants/app_constants.dart';
import 'package:doc_helper_app/core/common/constants/media_constants/animation_keys.dart';
import 'package:doc_helper_app/core/utils/enums.dart';
import 'package:doc_helper_app/core/utils/number_utils.dart';
import 'package:doc_helper_app/design/design.dart';
import 'package:doc_helper_app/design/molecules/bottomsheet/ds_bottom_sheet.dart';
import 'package:doc_helper_app/design/molecules/snackbar/ds_snackbar.dart';
import 'package:doc_helper_app/di/injection.dart';
import 'package:doc_helper_app/feature/billing/domain/entities/billing_entity.dart';
import 'package:doc_helper_app/feature/billing/presentation/bloc/payment_bloc.dart';
import 'package:doc_helper_app/feature/payment_gateway/domain/entities/payment_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

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
      builder: (context, state) => PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) =>
            didPop ? null : _onBackPressed(context: context, state: state),
        child: Scaffold(
          appBar: const PrimaryAppBar(titleText: 'Checkout'),
          body: switch (state) {
            OnPaymentSuccess _ => const _PaymentSuccessForm(),
            OnExternalWalletEvent _ =>
              const SizedBox(), // TODO: Handle this appropriately
            _ => const _PaymentForm(),
          },
        ),
      ),
      listener: _handleState,
    ),
  );

  void _handleState(BuildContext context, PaymentState state) {
    if (state.store.loading) {
      context.loaderOverlay.show();
    } else if (context.loaderOverlay.visible) {
      context.loaderOverlay.hide();
    }
    return switch (state) {
      OnCheckoutCreate _ => getBloc<PaymentBloc>(context).initiateTransaction(),
      OnTranasctionCancel(:final store) => _onTransactionCancelled(
        context: context,
        paymentFailure: store.paymentFailure,
        selectedPriceCode: state.store.selectedPriceCode,
      ),
      OnPaymentFailure _ => _onPaymentFailure(context: context),
      OnException(:final exception) => handleException(exception, context),
      _ => null,
    };
  }

  void _onBackPressed({
    required BuildContext context,
    required PaymentState state,
  }) {
    if (state.store.loading) {
      return;
    }
    if (state.store.refreshOnBackRequired) {
      GoRouter.of(context).pop({AppConstants.refreshRequired: true});
    } else {
      GoRouter.of(context).pop();
    }
  }

  void _onPaymentFailure({required BuildContext context}) {
    getBloc<PaymentBloc>(context).onPaymentFailed();
  }

  void _onTransactionCancelled({
    required BuildContext context,
    PaymentGatewayFailure? paymentFailure,
    String? selectedPriceCode,
  }) {
    final errorCode = paymentFailure?.code;
    return switch (errorCode) {
      Razorpay.NETWORK_ERROR ||
      Razorpay.TLS_ERROR => _showPaymentRetryBottomSheet(
        context: context,
        selectedPriceCode: selectedPriceCode,
      ),
      Razorpay.PAYMENT_CANCELLED => _handleManualPaymentCancellation(
        context: context,
      ),
      _ => _showPaymentFailureBottomSheet(
        context: context,
        selectedPriceCode: selectedPriceCode,
      ),
    };
  }

  void _showPaymentRetryBottomSheet({
    required BuildContext context,
    required String? selectedPriceCode,
  }) {
    DsBottomSheet.showBottomSheet(
      context: context,
      primaryButtonText: 'Retry',
      onPrimaryButtonTap: () => getBloc<PaymentBloc>(
        context,
      ).onCheckoutStarted(priceCode: selectedPriceCode),
      title: 'Payment Failed!',
      description: 'Please check your internet connection and try again.',
      showCloseButton: false,
      showDefaultIcon: false,
      icon: Icons.info_outline,
      iconColor: DsColors.iconError,
      secondaryButtonText: 'Cancel',
      isDismissible: false,
    );
  }

  void _handleManualPaymentCancellation({required BuildContext context}) {
    showSnackBar(
      context: context,
      message: 'Payment Cancelled',
      showCloseIcon: true,
      backgroundColor: DsColors.backgroundInfo,
      textColor: DsColors.textSuccess,
    );
  }

  void _showPaymentFailureBottomSheet({
    required BuildContext context,
    required String? selectedPriceCode,
  }) {
    DsBottomSheet.showBottomSheet(
      context: context,
      primaryButtonText: 'Retry',
      onPrimaryButtonTap: () => getBloc<PaymentBloc>(
        context,
      ).onCheckoutStarted(priceCode: selectedPriceCode),
      title: 'Payment Failed!',
      description:
          '''Failed to process your payment due to unknown reasons. Please try again.''',
      showCloseButton: false,
      showDefaultIcon: false,
      icon: Icons.info_outline,
      iconColor: DsColors.iconError,
      secondaryButtonText: 'Cancel',
      isDismissible: false,
    );
  }
}
