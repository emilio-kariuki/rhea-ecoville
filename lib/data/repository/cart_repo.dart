import 'package:ecoville/data/local/local_database.dart';
import 'package:ecoville/data/service/service_locator.dart';
import 'package:ecoville/models/local_product_model.dart';
import 'package:ecoville/utilities/packages.dart';

abstract class cartTemp{
  Future<bool> addToCart({required LocalProductModel product});
  Future<bool> removeFromCart({required String id});
  Future<List<LocalProductModel>> getCartProducts();
  Future<bool> clearCart();
  Future<bool> addToCartLater({required LocalProductModel product});
  Future<bool> removeFromCartLater({required String id});
  Future<List<LocalProductModel>> getLaterCartProducts();

}

class CartRepo extends cartTemp {
  final _dbHelper = service<DatabaseHelper>();
  @override
  Future<bool> addToCart({required LocalProductModel product}) async {
    try {
      final db = await _dbHelper.init();
      final currentUserId = supabase.auth.currentUser!.id;
      if (product.userId == currentUserId){
        debugPrint("User cant add their own products");
        return false;
      }

      final result = await _dbHelper.insertLocalProduct(
          db: db, product: product, table: LOCAL_TABLE_CART);
      return result > 0;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  @override
  Future<bool> addToCartLater({required LocalProductModel product}) async {
    try {
      final db = await _dbHelper.init();
      final currentUserId = supabase.auth.currentUser!.id;
      if (product.userId == currentUserId){
        debugPrint("User cant add their own products");
        return false;
      }
      await _dbHelper.insertLocalProduct(
          db: db, product: product, table: LOCAL_TABLE_LATER_CART);
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  @override
  Future<bool> clearCart() async {
    try{
      final db = await _dbHelper.init();
      await db.delete(LOCAL_TABLE_CART);
      return true;
    } catch (e){
      debugPrint(e.toString());
      return false;
    }
  }

  @override
  Future<List<LocalProductModel>> getCartProducts() async {
    try {
      final db = await _dbHelper.init();
      final result = await _dbHelper.getLocalProducts(db: db, table: LOCAL_TABLE_CART);
      return result;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  @override
  Future<List<LocalProductModel>> getLaterCartProducts() async {
    try {
      final db = await _dbHelper.init();
      final result = await _dbHelper.getLocalProducts(
          db: db, table: LOCAL_TABLE_LATER_CART);
      return result;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  @override
  Future<bool> removeFromCart({required String id}) async{
    try {
      final db = await _dbHelper.init();
      await _dbHelper.deleteLocalProduct(db: db, id: id, table: LOCAL_TABLE_CART);
      return true;
    } catch (e){
      debugPrint(e.toString());
      return false;
    }
  }

  @override
  Future<bool> removeFromCartLater({required String id}) async {
    try {
      final db = await _dbHelper.init();
      await _dbHelper.deleteLocalProduct(db: db, id: id, table: LOCAL_TABLE_LATER_CART);
      return true;
    } catch (e){
      return false;
    }
  }
}

