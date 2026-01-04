import 'package:doc_helper_app/feature/billing/domain/entities/billing_entity.dart';
import 'package:doc_helper_app/feature/payment_gateway/domain/entities/payment_event.dart';

abstract interface class IPaymentGatewayFacade {
  Future<void> startCheckout(CheckoutSessionInfo? session);
  Stream<PaymentGatewayEvent> get paymentGatewayStream;
  Future<void> dispose();
}
