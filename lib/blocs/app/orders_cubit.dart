import 'package:ecoville/data/repository/order_repository.dart';
import 'package:ecoville/models/order_model.dart';
import 'package:ecoville/models/order_request_model.dart';
import 'package:ecoville/utilities/packages.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(OrderState());

  void getUserOrders() async {
    emit(state.copyWith(status: OrderStatus.loading));
    try {
      final response = await OrderRepository().getUserOrders();
      debugPrint(response.toString());
      emit(state.copyWith(status: OrderStatus.loaded, orders: response));
    } catch (e) {
      emit(state.copyWith(status: OrderStatus.error, message: e.toString()));
    }
  }

  void getAllOrders() async {
    emit(state.copyWith(status: OrderStatus.loading));
    try {
      final response = await OrderRepository().getAllOrders();
      debugPrint(response.toString());
      emit(state.copyWith(status: OrderStatus.loaded, orders: response));
    } catch (e) {
      emit(state.copyWith(status: OrderStatus.error, message: e.toString()));
    }
  }

  void payOrder({
    required String orderId,
    required String phone,
    required int amount,
  }) async {
    emit(state.copyWith(status: OrderStatus.loading));
    try {
      final response = await OrderRepository().payOrder(
        orderId: orderId,
        phone: phone,
        amount: amount,
      );
      debugPrint(response.toString());
      getUserOrders();
      emit(state.copyWith(
        status: OrderStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(status: OrderStatus.error, message: e.toString()));
    }
  }

  void cancelOrder({required OrderModel order}) async {
    emit(state.copyWith(status: OrderStatus.loading));
    try {
      final response = await OrderRepository().cancelOrder(order: order);
      if (response) {
        getUserOrders();
        emit(state.copyWith(status: OrderStatus.updated));
      }
    } catch (e) {
      emit(state.copyWith(status: OrderStatus.error, message: e.toString()));
    }
  }

  void confirmOrder({required OrderModel order}) async {
    emit(state.copyWith(status: OrderStatus.loading));
    try {
      final response = await OrderRepository().confirmOrder(order: order);
      if (response) {
        getUserOrders();
        emit(state.copyWith(status: OrderStatus.updated));
      }
    } catch (e) {
      emit(state.copyWith(status: OrderStatus.error, message: e.toString()));
    }
  }

  void createOrder({required OrderRequestModel order}) async {
    emit(state.copyWith(status: OrderStatus.loading));
    try {
      final response = await OrderRepository().createOrder(order: order);
      if (response) {
        emit(state.copyWith(status: OrderStatus.success));
      }
    } catch (e) {
      emit(state.copyWith(status: OrderStatus.error, message: e.toString()));
    }
  }
}

enum OrderStatus { initial, loading, loaded, error, updated, success }

class OrderState {
  final List<OrderModel> orders;
  final OrderStatus status;
  final String message;

  OrderState(
      {this.orders = const [],
      this.status = OrderStatus.initial,
      this.message = ""});

  OrderState copyWith({
    List<OrderModel>? orders,
    OrderStatus? status,
    String? message,
  }) {
    return OrderState(
      orders: orders ?? this.orders,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}
