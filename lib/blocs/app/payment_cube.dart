import 'package:ecoville/data/service/service_locator.dart';
import 'package:ecoville/utilities/packages.dart';
import '../../data/provider/payment_prov.dart';

class PaymentCube extends Cubit<PaymentState>{
  final _paymentRepo = service<PaymentProv>();
  PaymentCube() : super(PaymentState());

  Future<void> initializePayment({required int phone, required double amount,
    required List<String> products})async {
    emit(state.copyWith( status: PaymentStatus.loading));
    try {
      final response = await _paymentRepo.initiatePayment(phone: phone, amount: amount, products: products);
      debugPrint('checkoutRequestID: ${response.checkoutRequestId}');
      emit(state.copyWith(status: PaymentStatus.initialized,
      checkoutRequestID: response.checkoutRequestId,
      products: products));
    } catch (e){
      emit(state.copyWith(status: PaymentStatus.failure, message: e.toString()));
    }
  }
  Future<void> confirmPayment() async {
    emit(state.copyWith(status: PaymentStatus.confirming));
    try {
      await _paymentRepo.confirmPayment(
          checkoutRequestID: state.checkoutRequestID, products: state.products);
      emit(state.copyWith(status: PaymentStatus.success));
    } catch (e){
      emit(state.copyWith(status: PaymentStatus.failure));
    }
  }
  Future<void> completePayment() async {
    emit(state.copyWith(status: PaymentStatus.loading));
    try {
      await _paymentRepo.completePayment(
          checkoutRequestID: state.checkoutRequestID, products: state.products);
      emit(state.copyWith(status: PaymentStatus.success));
    } catch (e) {
      emit(state.copyWith(status: PaymentStatus.failure));
    }
  }

}

enum PaymentStatus {initial, initialized, confirming, success, failure, loading}

class PaymentState{
  final PaymentStatus status;
  final String checkoutRequestID;
  final String? message;
  final List<String> products;

  PaymentState({
    this.status = PaymentStatus.initial,
    this.checkoutRequestID = '',
    this.message,
    this.products = const[]
  });
  PaymentState copyWith({
    PaymentStatus? status,
    String? checkoutRequestID,
    String? message,
    List<String>? products
  }) {
    return PaymentState(
      status: status?? this.status,
      checkoutRequestID: checkoutRequestID ?? this.checkoutRequestID,
      message: message ?? this.message,
      products: products ?? this.products
    );
  }
}