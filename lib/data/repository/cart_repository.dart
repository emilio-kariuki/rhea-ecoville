import 'package:ecoville/models/local_product_model.dart';
import 'package:ecoville/utilities/packages.dart';

abstract class CartTemplate {
  Future<bool> addToCart({required LocalProductModel product});
  Future<bool> removeFromCart({required String id});
  Future<List<LocalProductModel>> getCartProducts();
  Future<bool> clearCart();
}

class CartRepository extends CartTemplate {
  @override
  Future<bool> addToCart({required LocalProductModel product}) async{
    try {
      return true;
    } catch (error) {
      debugPrint(error.toString());
      return false;
    }
  }

  @override
  Future<bool> clearCart() {
    // TODO: implement clearCart
    throw UnimplementedError();
  }

  @override
  Future<List<LocalProductModel>> getCartProducts() {
    // TODO: implement getCartProducts
    throw UnimplementedError();
  }

  @override
  Future<bool> removeFromCart({required String id}) {
    // TODO: implement removeFromCart
    throw UnimplementedError();
  }
}
