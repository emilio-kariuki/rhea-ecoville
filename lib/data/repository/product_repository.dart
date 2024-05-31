import 'package:ecoville/data/local/local_database.dart';
import 'package:ecoville/data/provider/location_provider.dart';
import 'package:ecoville/data/service/service_locator.dart';
import 'package:ecoville/models/local_product_model.dart';
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
  Future<bool> saveProduct({required LocalProductModel product});
  Future<List<LocalProductModel>> getSavedProducts();
  Future<bool> unsaveProduct({required String id});
  Future<bool> watchProduct({required LocalProductModel product});
  Future<bool> unwatchProduct({required String id});
  Future<List<LocalProductModel>> getWatchedProducts();
  Future<bool> addProductToWishlist({required LocalProductModel product});
  Future<List<LocalProductModel>> getWishlistProducts();
  Future<bool> removeFromWishlist({required String id});
  Future<List<ProductModel>> getNearbyProducts();
  Future<List<ProductModel>> getSimilarProducts({required String productId});
  Future<bool> likeProduct({required LocalProductModel product});
  Future<List<LocalProductModel>> getLikedProducts();
  Future<bool> unlikeProduct({required String id});
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
      final db = await _dbHelper.init();
      final wishlist =
          await _dbHelper.getLocalProducts(db: db, table: LOCAL_TABLE_WISHLIST);
      final saved = await _dbHelper.getLocalProducts(
          db: db, table: LOCAL_TABLE_PRODUCT_SAVED);
      final favourite = await _dbHelper.getLocalProducts(
          db: db, table: LOCAL_TABLE_FAVOURITE);
      final response = await supabase
          .from(TABLE_PRODUCT)
          .select("ecoville_user(*), *, ecoville_product_category(*)")
          .eq('id', id);
      var product = ProductModel.fromJson(response.first);
      final isWishlist = wishlist.isEmpty
          ? false
          : wishlist.any((element) => element.id == product.id);
      final isSaved = saved.isEmpty
          ? false
          : saved.any((element) => element.id == product.id);
      final isFavourite = favourite.isEmpty
          ? false
          : favourite.any((element) => element.id == product.id);
      product = product.copyWith(
          wishlist: isWishlist, saved: isSaved, favourite: isFavourite);
      return product;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("Error getting the product, $e");
    }
  }

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final db = await _dbHelper.init();
      final favourites = await _dbHelper.getLocalProducts(
          db: db, table: LOCAL_TABLE_FAVOURITE);
      final response = await supabase
          .from(TABLE_PRODUCT)
          .select("ecoville_user(*), *, ecoville_product_category(*)")
          .limit(10);
      var products = response.map((e) => ProductModel.fromJson(e)).toList();
      debugPrint("network products: $products");
      if (favourites.isNotEmpty) {
        products = products.map((e) {
          final isFavourite = favourites.any((element) => element.id == e.id);
          return e.copyWith(favourite: isFavourite);
        }).toList();
      }
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
  Future<bool> saveProduct({required LocalProductModel product}) async {
    try {
      final db = await _dbHelper.init();
      await _dbHelper.insertLocalProduct(
          db: db, product: product, table: LOCAL_TABLE_PRODUCT_SAVED);
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
          db: db, id: id, table: LOCAL_TABLE_PRODUCT_SAVED);
      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("Error saving the product, $e");
    }
  }

  @override
  Future<List<LocalProductModel>> getSavedProducts() async {
    try {
      final db = await _dbHelper.init();
      final savedProducts = await _dbHelper.getUserLocalProducts(
          db: db, table: LOCAL_TABLE_PRODUCT_SAVED);
      return savedProducts;
    } catch (error) {
      debugPrint(error.toString());
      throw Exception("Error getting the products, $error");
    }
  }

  @override
  Future<List<LocalProductModel>> getWatchedProducts() async {
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
  Future<bool> watchProduct({required LocalProductModel product}) async {
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
      // final userId = supabase.auth.currentUser!.id;
      final db = await _dbHelper.init();
      final favourites = await _dbHelper.getLocalProducts(
          db: db, table: LOCAL_TABLE_FAVOURITE);
      final response = await supabase.from(TABLE_PRODUCT).select("ecoville_user(*), ecoville_product_category(*),*");
      for (var e in response) {
        final product = ProductModel.fromJson(e);
        final isWithinRange =
            await _locationProvider.isWithinRadiusFromCurrentLocation(
                end: Position(
                    longitude: product.address.lat,
                    latitude: product.address.lon,
                    timestamp: DateTime.now(),
                    accuracy: 1.0,
                    altitude: 1.0,
                    heading: 1.0,
                    altitudeAccuracy: 1.0,
                    headingAccuracy: 1.0,
                    speed: 0,
                    speedAccuracy: 1),
                radius: NEARBY_RADIUS);

        if (isWithinRange) {
          nearbyProducts.add(product);
        }
      }
       if (favourites.isNotEmpty) {
        nearbyProducts = nearbyProducts.map((e) {
          final isFavourite = favourites.any((element) => element.id == e.id);
          return e.copyWith(favourite: isFavourite);
        }).toList();
      }
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

  @override
  Future<bool> addProductToWishlist(
      {required LocalProductModel product}) async {
    try {
      final db = await _dbHelper.init();
      final savedProducts = await _dbHelper.insertLocalProduct(
          db: db, product: product, table: LOCAL_TABLE_WISHLIST);
      return savedProducts;
    } catch (error) {
      debugPrint(error.toString());
      throw Exception("Error inserting the wishlist product, $error");
    }
  }

  @override
  Future<List<LocalProductModel>> getWishlistProducts() async {
    try {
      final db = await _dbHelper.init();
      final savedProducts =
          await _dbHelper.getLocalProducts(db: db, table: LOCAL_TABLE_WISHLIST);
      return savedProducts;
    } catch (error) {
      debugPrint(error.toString());
      throw Exception("Error getting the wishlist products, $error");
    }
  }

  @override
  Future<List<LocalProductModel>> getLikedProducts() async {
    try {
      final db = await _dbHelper.init();
      final savedProducts = await _dbHelper.getUserLocalProducts(
          db: db, table: LOCAL_TABLE_FAVOURITE);
      return savedProducts;
    } catch (error) {
      debugPrint(error.toString());
      throw Exception("Error getting the liked products, $error");
    }
  }

  @override
  Future<bool> likeProduct({required LocalProductModel product}) async {
    try {
      final db = await _dbHelper.init();
      await _dbHelper.insertLocalProduct(
          db: db, product: product, table: LOCAL_TABLE_FAVOURITE);
      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("Error liking the product, $e");
    }
  }

  @override
  Future<bool> unlikeProduct({required String id}) async {
    try {
      final db = await _dbHelper.init();

      await _dbHelper.deleteLocalProduct(
          db: db, id: id, table: LOCAL_TABLE_FAVOURITE);
      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("Error liking the product, $e");
    }
  }

  @override
  Future<bool> removeFromWishlist({required String id}) async {
    try {
      final db = await _dbHelper.init();

      await _dbHelper.deleteLocalProduct(
          db: db, id: id, table: LOCAL_TABLE_WISHLIST);
      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("Error liking the product, $e");
    }
  }
}
