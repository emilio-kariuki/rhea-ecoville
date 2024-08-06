import 'package:ecoville/models/confirm_payment_model.dart';
import 'package:ecoville/models/initiated_payment_model.dart';
import '../repository/payment_repo.dart';

class PaymentProv extends PaymentTemp {
  final PaymentRepo _paymentRepo;
  PaymentProv({required PaymentRepo paymentRepo})
  : _paymentRepo = paymentRepo;

  @override
  Future<void> completePayment({required String checkoutRequestID, required List<String> products}) {
    return _paymentRepo.completePayment(checkoutRequestID: checkoutRequestID, products: products);
  }

  @override
  Future<ConfirmPaymentModel> confirmPayment({required String checkoutRequestID, required List<String> products}) {
    return _paymentRepo.confirmPayment(checkoutRequestID: checkoutRequestID, products: products);
  }

  @override
  Future<InitiatedPaymentModel> initiatePayment({required int phone, required double amount, required List<String> products}) {
    return _paymentRepo.initiatePayment(phone: phone, amount: amount, products: products);
  }

}