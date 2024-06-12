import 'package:ecoville/data/local/local_database.dart';
import 'package:ecoville/data/service/service_locator.dart';
import 'package:ecoville/models/local_product_model.dart';
import 'package:ecoville/utilities/packages.dart';

abstract class CartTemplate {
  Future<bool> addToCart({required LocalProductModel product});
  Future<bool> removeFromCart({required String id});
  Future<List<LocalProductModel>> getCartProducts();
  Future<bool> clearCart();
}

class CartRepository extends CartTemplate {
  final _dbHelper = service<DatabaseHelper>();
  @override
  Future<bool> addToCart({required LocalProductModel product}) async {
    try {
      final db = await _dbHelper.init();
      final result = await _dbHelper.insertLocalProduct(
          db: db, product: product, table: LOCAL_TABLE_CART);
      return result > 0;
    } catch (error) {
      debugPrint(error.toString());
      return false;
    }
  }

  @override
  Future<bool> clearCart() async {
    try {
      final db = await _dbHelper.init();
      await db.delete(LOCAL_TABLE_CART);
      return true;
    } catch (error) {
      debugPrint(error.toString());
      return false;
    }
  }

  @override
  Future<List<LocalProductModel>> getCartProducts() async {
    try {
      final db = await _dbHelper.init();
      final result =
          await _dbHelper.getLocalProducts(db: db, table: LOCAL_TABLE_CART);
      return result;
    } catch (error) {
      debugPrint(error.toString());
      return [];
    }
  }

  @override
  Future<bool> removeFromCart({required String id}) async {
    try {
      final db = await _dbHelper.init();
      await _dbHelper.deleteLocalProduct(
          db: db, id: id, table: LOCAL_TABLE_CART);
      return true;
    } catch (error) {
      debugPrint(error.toString());
      return false;
    }
  }
}
