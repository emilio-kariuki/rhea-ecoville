import 'package:ecoville/data/repository/cart_repository.dart';
import 'package:ecoville/models/local_product_model.dart';
import 'package:ecoville/models/rating_model.dart';

class CartProvider extends CartTemplate {
  final CartRepository _cartRepository;
  CartProvider({required CartRepository cartRepository})
      : _cartRepository = cartRepository;

  @override
  Future<bool> addToCart({required LocalProductModel product}) {
    return _cartRepository.addToCart(product: product);
  }

  @override
  Future<bool> clearCart() {
    return _cartRepository.clearCart();
  }

  @override
  Future<List<LocalProductModel>> getCartProducts() {
    return _cartRepository.getCartProducts();
  }

  @override
  Future<bool> removeFromCart({required String id}) {
    return _cartRepository.removeFromCart(id: id);
  }


}
