import 'dart:async';

import 'package:doc_helper_app/feature/billing/domain/entities/billing_entity.dart';
import 'package:doc_helper_app/feature/payment_gateway/domain/entities/payment_event.dart';
import 'package:doc_helper_app/feature/payment_gateway/domain/interface/i_payment_gateway_facade.dart';
import 'package:injectable/injectable.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

@Injectable(as: IPaymentGatewayFacade)
class RazorpayPaymentGateway implements IPaymentGatewayFacade {
  RazorpayPaymentGateway() {
    _razorpay = Razorpay();
    _razorpay?.on(Razorpay.EVENT_PAYMENT_SUCCESS, _onSuccess);
    _razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR, _onError);
    _razorpay?.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  Razorpay? _razorpay;
  StreamController<PaymentGatewayEvent>? _controller;

  @override
  Future<void> startCheckout(CheckoutSessionInfo? session) async {
    if(!(_controller?.isClosed ?? false)) {
      _controller?.close();
    }
    _controller =  StreamController<PaymentGatewayEvent>();
    final options = {
      'key': session?.providerKeyId,
      'subscription_id': session?.providerSubscriptionId,
      'name': 'Doc Helper',
      'description': 'Subscription',
    };

    _razorpay?.open(options);
  }

  void _onSuccess(PaymentSuccessResponse res) {
    _controller?.add(
      PaymentGatewaySuccess(
        paymentId: res.paymentId,
        orderId: res.orderId,
        signature: res.signature,
      ),
    );
  }

  void _onError(PaymentFailureResponse res) {
    _controller?.add(
      PaymentGatewayEvent.failure(code: res.code, message: res.message),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    _controller?.add(
      PaymentGatewayEvent.externalWallet(walletName: response.walletName),
    );
  }

  @override
  Stream<PaymentGatewayEvent>? get paymentGatewayStream => _controller?.stream;

  @override
  Future<void> dispose() async {
    _razorpay?.clear();
    await _controller?.close();
  }
}
