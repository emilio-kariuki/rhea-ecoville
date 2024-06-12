import 'package:ecoville/data/repository/payment_repository.dart';
import 'package:ecoville/models/confirm_payment_model.dart';
import 'package:ecoville/models/initiated_payment_model.dart';

class PaymentProvider extends PaymentTemplate {
  final PaymentRepository _paymentRepository;
  PaymentProvider({required PaymentRepository paymentRepository})
      : _paymentRepository = paymentRepository;

  @override
  Future<void> completePayment(
      {required String checkoutRequestID, required List<String> products}) {
    return _paymentRepository.completePayment(
        checkoutRequestID: checkoutRequestID, products: products);
  }

  @override
  Future<ConfirmPaymentModel> confirmPayment(
      {required String checkoutRequestID, required List<String> products}) {
    return _paymentRepository.confirmPayment(
        checkoutRequestID: checkoutRequestID, products: products);
  }

  @override
  Future<InitiatedPaymentModel> initiatePayment(
      {required int phone,
      required double amount,
      required List<String> products}) {
    return _paymentRepository.initiatePayment(
        phone: phone, amount: amount, products: products);
  }
}
