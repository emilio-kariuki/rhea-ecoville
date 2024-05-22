import 'package:ecoville/data/local/local_database.dart';
import 'package:ecoville/data/provider/location_provider.dart';
import 'package:ecoville/data/service/service_locator.dart';
import 'package:ecoville/models/product_model.dart';
import 'package:ecoville/utilities/packages.dart';

abstract class ProductTemplate {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> getProduct({required String id});
  Future<List<ProductModel>> getProductsByCategory(
      {required String categoryId});
  Future<List<ProductModel>> getUserProductsPosted();
  Future<bool> createProduct(
      {required ProductModel product, required bool allowBidding});
  Future<bool> updateProduct({required ProductModel product});
  Future<bool> deleteProduct({required String id});
  Future<bool> saveProduct({required ProductModel product});
  Future<List<ProductModel>> getSavedProducts();
  Future<bool> unsaveProduct({required String id});
  Future<bool> watchProduct({required ProductModel product});
  Future<bool> unwatchProduct({required String id});
  Future<List<ProductModel>> getWatchedProducts();
  Future<List<ProductModel>> getNearbyProducts();
  Future<List<ProductModel>> getSimilarProducts({required String productId});
}

class ProductRepository extends ProductTemplate {
  final _dbHelper = service<DatabaseHelper>();
  final _locationProvider = service<LocationProvider>();
  @override
  Future<bool> createProduct(
      {required ProductModel product, required bool allowBidding}) async {
    try {
      await supabase.from(TABLE_PRODUCT).insert(product.toJson());
      return true;
    } catch (error) {
      debugPrint(error.toString());
      throw Exception("Error creating the product, $error");
    }
  }

  @override
  Future<bool> updateProduct({required ProductModel product}) async {
    try {
      await supabase
          .from(TABLE_PRODUCT)
          .update(product.toJson())
          .eq('id', product.id);
      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("Error saving the product, $e");
    }
  }

  @override
  Future<bool> deleteProduct({required String id}) async {
    try {
      await supabase.from(TABLE_PRODUCT).delete().eq('id', id);
      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("Error deleting the product, $e");
    }
  }

  @override
  Future<ProductModel> getProduct({required String id}) async {
    try {
      final response = await supabase.from(TABLE_PRODUCT).select().eq('id', id);
      final product = ProductModel.fromJson(response.first);
      return product;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("Error getting the product, $e");
    }
  }

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await supabase
          .from(TABLE_PRODUCT)
          .select("ecoville_user(*), *, ecoville_category(*)");
      final products = response.map((e) => ProductModel.fromJson(e)).toList();
      return products;
    } catch (error) {
      debugPrint(error.toString());
      throw Exception("Error getting the products, $error");
    }
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(
      {required String categoryId}) async {
    try {
      final response = await supabase
          .from(TABLE_PRODUCT)
          .select("ecoville_user(*), *, ecoville_category(*)")
          .eq('categoryId', categoryId);
      final products = response.map((e) => ProductModel.fromJson(e)).toList();
      return products;
    } catch (error) {
      debugPrint(error.toString());
      throw Exception("Error getting the products, $error");
    }
  }

  @override
  Future<List<ProductModel>> getUserProductsPosted() async {
    try {
      final userId = supabase.auth.currentUser!.id;
      final response = await supabase
          .from(TABLE_PRODUCT)
          .select("ecoville_user(*), *, ecoville_category(*)")
          .eq('userId', userId);
      final products = response.map((e) => ProductModel.fromJson(e)).toList();
      return products;
    } catch (error) {
      debugPrint(error.toString());
      throw Exception("Error getting the products, $error");
    }
  }

  @override
  Future<bool> saveProduct({required ProductModel product}) async {
    try {
      final db = await _dbHelper.init();

      await _dbHelper.insertLocalProduct(
          db: db, product: product, table: LOCAL_TABLE_PRODUCTS);
      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("Error saving the product, $e");
    }
  }

  @override
  Future<bool> unsaveProduct({required String id}) async {
    try {
      final db = await _dbHelper.init();

      await _dbHelper.deleteLocalProduct(
          db: db, id: id, table: LOCAL_TABLE_PRODUCTS);
      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("Error saving the product, $e");
    }
  }

  @override
  Future<List<ProductModel>> getSavedProducts() async {
    try {
      final db = await _dbHelper.init();
      final savedProducts = await _dbHelper.getUserLocalProducts(
          db: db, table: LOCAL_TABLE_PRODUCTS);
      return savedProducts;
    } catch (error) {
      debugPrint(error.toString());
      throw Exception("Error getting the products, $error");
    }
  }

  @override
  Future<List<ProductModel>> getWatchedProducts() async {
    try {
      final db = await _dbHelper.init();
      final savedProducts = await _dbHelper.getUserLocalProducts(
          db: db, table: LOCAL_TABLE_WATCHED);
      return savedProducts;
    } catch (error) {
      debugPrint(error.toString());
      throw Exception("Error getting the watched products, $error");
    }
  }

  @override
  Future<bool> unwatchProduct({required String id}) async {
    try {
      final db = await _dbHelper.init();

      await _dbHelper.deleteLocalProduct(
          db: db, id: id, table: LOCAL_TABLE_WATCHED);
      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("Error saving the product, $e");
    }
  }

  @override
  Future<bool> watchProduct({required ProductModel product}) async {
    try {
      final db = await _dbHelper.init();

      await _dbHelper.insertLocalProduct(
          db: db, product: product, table: LOCAL_TABLE_WATCHED);
      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("Error saving the product, $e");
    }
  }

  @override
  Future<List<ProductModel>> getNearbyProducts() async {
    try {
      var nearbyProducts = <ProductModel>[];
      final userId = supabase.auth.currentUser!.id;
      final response =
          await supabase.from(TABLE_PRODUCT).select().neq('userId', userId);
      response.map((e) => ProductModel.fromJson(e)).toList().map((e) async {
        final isWithinRange =
            await _locationProvider.isWithinRadiusFromCurrentLocation(
                end: Position(
                    longitude: e.address.lat,
                    latitude: e.address.lon,
                    timestamp: DateTime.now(),
                    accuracy: 0.0,
                    altitude: 0.0,
                    heading: 0.0,
                    altitudeAccuracy: 0.0,
                    headingAccuracy: 0.0,
                    speed: 0.0,
                    speedAccuracy: 0),
                radius: NEARBY_RADIUS);
        if (isWithinRange) {
          nearbyProducts.add(e);
        }
      });
      return nearbyProducts;
    } catch (error) {
      debugPrint(error.toString());
      throw Exception("Error getting the nearby products, $error");
    }
  }

  @override
  Future<List<ProductModel>> getSimilarProducts(
      {required String productId}) async {
    try {
      final response =
          await supabase.from(TABLE_PRODUCT).select().eq('id', productId);
      final product = ProductModel.fromJson(response.first);
      final category = product.categoryId;
      final similarResponse = await supabase
          .from(TABLE_PRODUCT)
          .select()
          .eq('categoryId', category)
          .neq('id', productId)
          .ilike("name", '%${product.name}%')
          .limit(8);
      return similarResponse.map((e) => ProductModel.fromJson(e)).toList();
    } catch (error) {
      debugPrint(error.toString());
      throw Exception("Error getting the similar products, $error");
    }
  }
}
