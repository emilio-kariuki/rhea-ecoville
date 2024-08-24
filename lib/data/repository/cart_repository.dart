import 'package:ecoville/data/local/local_database.dart';
import 'package:ecoville/data/service/service_locator.dart';
import 'package:ecoville/models/local_product_model.dart';
import 'package:ecoville/utilities/packages.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

abstract class CartTemplate {
  Future<bool> addToCart({required LocalProductModel product});
  Future<bool> removeFromCart({required String id});
  Future<List<LocalProductModel>> getCartProducts();
  Future<bool> clearCart();
  Future<bool> addToCartLater({required LocalProductModel product});
  Future<bool> removeFromCartLater({required String id});
  Future<List<LocalProductModel>> getLaterCartProducts();
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
    } catch (error, stackTrace) {
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );

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
    } catch (error, stackTrace) {
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );

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
    } catch (error, stackTrace) {
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );

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
    } catch (error, stackTrace) {
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );

      debugPrint(error.toString());
      return false;
    }
  }

  @override
  Future<bool> addToCartLater({required LocalProductModel product}) async {
    try {
      final db = await _dbHelper.init();
      await _dbHelper.insertLocalProduct(
          db: db, product: product, table: LOCAL_TABLE_LATER_CART);
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
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
  Future<bool> removeFromCartLater({required String id}) async {
    try {
      final db = await _dbHelper.init();
      await _dbHelper.deleteLocalProduct(
          db: db, id: id, table: LOCAL_TABLE_LATER_CART);
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
