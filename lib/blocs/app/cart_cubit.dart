import 'package:ecoville/data/provider/cart_provider.dart';
import 'package:ecoville/data/service/service_locator.dart';
import 'package:ecoville/models/local_product_model.dart';
import 'package:ecoville/utilities/packages.dart';

/// `CartCubit` manages the state and business logic related to the shopping cart.
/// This class extends `Cubit<CartState>` and handles actions like adding, removing, and clearing items from the cart
class CartCubit extends Cubit<CartState> {
  final _cartProvider = service<CartProvider>();
  CartCubit() : super(CartState());

  /// Adds an item to the cart.
  /// Emits an initial state, then either a success state if the item is added or an error state if it fails.

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

  /// Retrieves all items in the cart.
  Future<void> getCartItems() async {
    emit(state.copyWith(status: CartStatus.loading));
    try {
      final cartItems = await _cartProvider.getCartProducts();
      emit(state.copyWith(status: CartStatus.success, cartItems: cartItems));
    } catch (e) {
      emit(state.copyWith(status: CartStatus.error, message: e.toString()));
    }
  }



  /// Removes an item from the cart by its ID.
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

  /// Clears all items from the cart.
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

  /// Adds an item to the "Save for Later" list
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

  /// Retrieves all items in the "Save for Later" list.
  Future<void> getLaterCartItems() async {
    emit(state.copyWith(status: CartStatus.loading));
    try {
      final cartItems = await _cartProvider.getLaterCartProducts();
      emit(state.copyWith(status: CartStatus.success, cartItems: cartItems));
    } catch (e) {
      emit(state.copyWith(status: CartStatus.error, message: e.toString()));
    }
  }

  /// Removes an item from the "Save for Later" list by its ID.
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

/// `CartState` represents the state of the cart.
/// It includes the status, list of items in the cart, list of items in the "Save for Later" list, and any error messages.
class CartState {
  final CartStatus status; // Current status of the cart.
  final List<LocalProductModel> cartItems; // List of items currently in the cart.
  final List<LocalProductModel> laterCartItems; // List of items saved for later.
  final String message; // Any error or status messages.


  CartState(
      {this.status = CartStatus.initial,
      this.cartItems = const [],
      this.laterCartItems = const [],
      this.message = ''});

  /// `copyWith` allows for creating a new `CartState` with modified properties while retaining the existing ones.
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
