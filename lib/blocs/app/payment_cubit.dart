import 'package:ecoville/data/provider/payment_provider.dart';
import 'package:ecoville/data/service/service_locator.dart';
import 'package:ecoville/utilities/packages.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final _paymentRepository = service<PaymentProvider>();
  PaymentCubit() : super(PaymentState());

  Future<void> initializePayment({
    required int phone,
    required double amount,
    required List<String> products,
  }) async {
    emit(state.copyWith(status: PaymentStatus.loading));
    try {
      final response = await _paymentRepository.initiatePayment(
        phone: phone,
        amount: amount,
        products: products,
      );
      debugPrint('checkoutRequestID: ${response.checkoutRequestId}');
      emit(state.copyWith(
        status: PaymentStatus.success,
        checkoutRequestID: response.checkoutRequestId,
        products: products,
      ));
    } catch (e) {
      emit(
          state.copyWith(status: PaymentStatus.failure, message: e.toString()));
    }
  }

  Future<void> confirmPayment() async {
    emit(state.copyWith(status: PaymentStatus.loading));
    try {
      await _paymentRepository.confirmPayment(
        checkoutRequestID: state.checkoutRequestID,
        products: state.products,
      );
      emit(state.copyWith(status: PaymentStatus.success));
    } catch (e) {
      emit(
          state.copyWith(status: PaymentStatus.failure, message: e.toString()));
    }
  }

  Future<void> completePayment() async {
    emit(state.copyWith(status: PaymentStatus.loading));
    try {
      await _paymentRepository.completePayment(
        checkoutRequestID: state.checkoutRequestID,
        products: state.products,
      );
      emit(state.copyWith(status: PaymentStatus.success));
    } catch (e) {
      emit(
          state.copyWith(status: PaymentStatus.failure, message: e.toString()));
    }
  }
}

enum PaymentStatus { initial, loading, success, failure }

class PaymentState {
  final PaymentStatus status;
  final String checkoutRequestID;
  final String? message;
  final List<String> products;

  PaymentState(
      {this.status = PaymentStatus.initial,
      this.message,
      this.checkoutRequestID = '',
      this.products = const []});

  PaymentState copyWith({
    PaymentStatus? status,
    String? checkoutRequestID,
    String? message,
    List<String>? products,
  }) {
    return PaymentState(
      status: status ?? this.status,
      checkoutRequestID: checkoutRequestID ?? this.checkoutRequestID,
      message: message ?? this.message,
      products: products ?? this.products,
    );
  }
}
