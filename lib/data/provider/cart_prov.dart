import 'package:ecoville/data/repository/cart_repo.dart';
import 'package:ecoville/data/repository/cart_repository.dart';
import 'package:ecoville/models/local_product_model.dart';

class CartProv extends cartTemp{
  final CartRepo _cartRepo;
  CartProv({required CartRepo cartRepository})
  : _cartRepo = cartRepository;

  @override
  Future<bool> addToCart({required LocalProductModel product}) async{
    return _cartRepo.addToCart(product: product);
  }

  @override
  Future<bool> addToCartLater({required LocalProductModel product}) {
    return _cartRepo.addToCartLater(product: product);
  }

  @override
  Future<bool> clearCart() {
    return _cartRepo.clearCart();
  }

  @override
  Future<List<LocalProductModel>> getCartProducts() {
    return _cartRepo.getCartProducts();
  }

  @override
  Future<List<LocalProductModel>> getLaterCartProducts() {
    return _cartRepo.getLaterCartProducts();
  }

  @override
  Future<bool> removeFromCart({required String id}) {
    return _cartRepo.removeFromCart(id: id);
  }

  @override
  Future<bool> removeFromCartLater({required String id}) {
    return _cartRepo.removeFromCartLater(id: id);
  }

}