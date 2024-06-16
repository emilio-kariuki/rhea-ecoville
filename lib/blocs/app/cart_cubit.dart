import 'package:ecoville/data/provider/cart_provider.dart';
import 'package:ecoville/data/service/service_locator.dart';
import 'package:ecoville/models/local_product_model.dart';
import 'package:ecoville/utilities/packages.dart';

class CartCubit extends Cubit<CartState> {
  final _cartProvider = service<CartProvider>();
  CartCubit() : super(CartState());

  Future<void> addItemToCart({required LocalProductModel product}) async {
    emit(state.copyWith(status: CartStatus.initial));
    try {
      final result = await _cartProvider.addToCart(product: product);
      if (result) {
        emit(state.copyWith(status: CartStatus.success));
      } else {
        emit(state.copyWith(
            status: CartStatus.error, message: 'Failed to add item to cart'));
      }
    } catch (e) {
      emit(state.copyWith(status: CartStatus.error, message: e.toString()));
    }
  }

  Future<void> getCartItems() async {
    emit(state.copyWith(status: CartStatus.loading));
    try {
      final cartItems = await _cartProvider.getCartProducts();
      emit(state.copyWith(status: CartStatus.success, cartItems: cartItems));
    } catch (e) {
      emit(state.copyWith(status: CartStatus.error, message: e.toString()));
    }
  }



  Future<void> removeItemFromCart({required String id}) async {
    emit(state.copyWith(status: CartStatus.initial));
    try {
      final result = await _cartProvider.removeFromCart(id: id);
      if (result) {
        emit(state.copyWith(status: CartStatus.success));
      } else {
        emit(state.copyWith(
            status: CartStatus.error,
            message: 'Failed to remove item from cart'));
      }
    } catch (e) {
      emit(state.copyWith(status: CartStatus.error, message: e.toString()));
    }
  }

  Future<void> clearCart() async {
    emit(state.copyWith(status: CartStatus.initial));
    try {
      final result = await _cartProvider.clearCart();
      if (result) {
        emit(state.copyWith(status: CartStatus.success));
      } else {
        emit(state.copyWith(
            status: CartStatus.error, message: 'Failed to clear cart'));
      }
    } catch (e) {
      emit(state.copyWith(status: CartStatus.error, message: e.toString()));
    }
  }

  Future<void> addItemToCartLater({required LocalProductModel product}) async {
    emit(state.copyWith(status: CartStatus.initial));
    try {
      final result = await _cartProvider.addToCartLater(product: product);
      if (result) {
        emit(state.copyWith(status: CartStatus.success));
      } else {
        emit(state.copyWith(
            status: CartStatus.error, message: 'Failed to add item to cart'));
      }
    } catch (e) {
      emit(state.copyWith(status: CartStatus.error, message: e.toString()));
    }
  }

  Future<void> getLaterCartItems() async {
    emit(state.copyWith(status: CartStatus.loading));
    try {
      final cartItems = await _cartProvider.getLaterCartProducts();
      emit(state.copyWith(status: CartStatus.success, cartItems: cartItems));
    } catch (e) {
      emit(state.copyWith(status: CartStatus.error, message: e.toString()));
    }
  }

  Future<void> removeItemFromCartLater({required String id}) async {
    emit(state.copyWith(status: CartStatus.initial));
    try {
      final result = await _cartProvider.removeFromCartLater(id: id);
      if (result) {
        emit(state.copyWith(status: CartStatus.success));
      } else {
        emit(state.copyWith(
            status: CartStatus.error,
            message: 'Failed to remove item from cart'));
      }
    } catch (e) {
      emit(state.copyWith(status: CartStatus.error, message: e.toString()));
    }
  }
}

enum CartStatus { initial, loading, success, error }

class CartState {
  final CartStatus status;
  final List<LocalProductModel> cartItems;
  final List<LocalProductModel> laterCartItems;
  final String message;

  CartState(
      {this.status = CartStatus.initial,
      this.cartItems = const [],
      this.laterCartItems = const [],
      this.message = ''});

  CartState copyWith(
      {CartStatus? status,
      List<LocalProductModel>? cartItems,
      List<LocalProductModel>? laterCartItems,
      String? message}) {
    return CartState(
        status: status ?? this.status,
        cartItems: cartItems ?? this.cartItems,
        laterCartItems: laterCartItems ?? this.laterCartItems,
        message: message ?? this.message);
  }
}
