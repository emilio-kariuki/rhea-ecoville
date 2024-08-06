import 'package:ecoville/data/provider/cart_provider.dart';
import 'package:ecoville/data/service/service_locator.dart';
import 'package:ecoville/models/local_product_model.dart';
import 'package:ecoville/utilities/packages.dart';
import '../../data/provider/cart_prov.dart';

class CartCube extends Cubit<CartState>{
  final _cartProv = service<CartProv>();
  CartCube(): super(CartState());

  Future<void> addItemToCart({required LocalProductModel product})async {
    emit(state.copyWith(status: CartStatus.initial));
    try {
      final result = await _cartProv.addToCart(product: product);
      if (result) {
        emit(state.copyWith(status: CartStatus.success));
      } else {
        emit(state.copyWith(
            status: CartStatus.error, message: 'Failed to Connect'));
      }
    } catch (e){
      emit(state.copyWith(status: CartStatus.error, message: e.toString()));
    }
  }
  Future<void> getCartItems() async{
    emit(state.copyWith(status: CartStatus.initial));
    try {
      final cartItems = await _cartProv.getCartProducts();
        emit(state.copyWith(status: CartStatus.success, cartItems: cartItems));
    } catch (e){
      emit(state.copyWith(status: CartStatus.error, message: e.toString()));
    }
  }
  Future<void> removeItemFromCart({required id}) async{
    emit(state.copyWith(status: CartStatus.initial));
    try {
      final result = await _cartProv.removeFromCart(id: id);
      if (result) {
        emit(state.copyWith(status: CartStatus.success));
      } else {
        emit(state.copyWith(
            status: CartStatus.error, message: 'Failed to Connect'));
      }
    } catch (e){
      emit(state.copyWith(status: CartStatus.error, message: e.toString()));
    }
  }
  Future<void> clearCart() async{
    emit(state.copyWith(status: CartStatus.initial));
    try {
      final result = await _cartProv.clearCart();
      if (result) {
        emit(state.copyWith(status: CartStatus.success));
      } else {
        emit(state.copyWith(
            status: CartStatus.error, message: 'Failed to Connect'));
      }
    } catch (e) {
      emit(state.copyWith(status: CartStatus.error, message : e.toString()));

    }


  }
}
enum CartStatus{initial, loading , success, error}

class CartState{
  final CartStatus status;
  final List<LocalProductModel> cartItems;
  final List<LocalProductModel> laterCartItems;
  final String message;

  CartState({
    this.status = CartStatus.initial,
    this.cartItems = const[],
    this.laterCartItems = const[],
    this.message = ''});

  CartState copyWith({
    CartStatus ? status,
    List<LocalProductModel>? cartItems,
    List<LocalProductModel>? laterCartItems,
    String? message}) {
    return CartState(
      status: status ?? this.status,
      cartItems: cartItems ?? this.cartItems,
      laterCartItems: laterCartItems ?? this.laterCartItems,
      message: message ?? this.message
    );}
}





