import 'package:ecoville/data/provider/cart_provider.dart';
import 'package:ecoville/data/service/service_locator.dart';
import 'package:ecoville/models/local_product_model.dart';
import 'package:ecoville/utilities/packages.dart';

class CartCubit extends Cubit<CartState> {
  final _cartProvider = service<CartProvider>();
  CartCubit() : super(CartState());

  // Future<void> addItemToCart({required LocalProductModel product}) async {
  //   emit(state.copyWith(status: CartStatus.initial));
  //   try {
      
  //     emit(state.copyWith(status: CartStatus.success, cartItems: cartItems));
  //   } catch (e) {
  //     emit(state.copyWith(status: CartStatus.error, message: e.toString()));
  //   }
  // }
}

enum CartStatus { initial, loading, success, error }

class CartState {
  final CartStatus status;
  final List<LocalProductModel> cartItems;
  final String message;

  CartState(
      {this.status = CartStatus.initial,
      this.cartItems = const [],
      this.message = ''});

  CartState copyWith(
      {CartStatus? status,
      List<LocalProductModel>? cartItems,
      String? message}) {
    return CartState(
        status: status ?? this.status,
        cartItems: cartItems ?? this.cartItems,
        message: message ?? this.message);
  }
}
