import 'package:doc_helper_app/core/common/utils/app_utils.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_event.freezed.dart';

@liteFreezed
sealed class PaymentGatewayEvent with _$PaymentGatewayEvent {
  const factory PaymentGatewayEvent.success({
    String? paymentId,
    String? orderId,
    String? signature,
  }) = PaymentGatewaySuccess;

  const factory PaymentGatewayEvent.failure({
    int? code,
    String? message,
  }) = PaymentGatewayFailure;

  const factory PaymentGatewayEvent.externalWallet({
    String? walletName,
  }) = PaymentGatewayExternalWallet;
}