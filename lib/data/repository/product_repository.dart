import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ecoville/data/local/local_database.dart';
import 'package:ecoville/data/provider/location_provider.dart';
import 'package:ecoville/data/service/service_locator.dart';
import 'package:ecoville/models/category_model.dart';
import 'package:ecoville/models/local_product_model.dart';
import 'package:ecoville/models/product_model.dart';
import 'package:ecoville/models/product_request_model.dart';
import 'package:ecoville/utilities/packages.dart';

abstract class ProductTemplate {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> getProduct({required String id});
  Future<List<ProductModel>> getProductsByCategory(
      {required String categoryId});
  Future<List<ProductModel>> getUserProductsPosted();
  Future<bool> createProduct(
      {required ProductRequestModel product, required bool allowBidding});
  Future<bool> updateProduct({required ProductModel product});
  Future<bool> deleteProduct({required String id});
  Future<bool> saveProduct({required String productId});
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
  Future<List<CategoryModel>> getCategories();
  Future<List<ProductModel>> searchResults({required String name});
}

class ProductRepository extends ProductTemplate {
  final _dbHelper = service<DatabaseHelper>();
  final _locationProvider = service<LocationProvider>();

  @override
  Future<bool> createProduct(
      {required ProductRequestModel product,
      required bool allowBidding}) async {
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
          .eq('id', product.id!);
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
      final response = await Dio().get(
          "http://localhost:4003/api/product/get/$id",
          options: Options(headers: {
            "APIKEY": API_KEY,
            "user": supabase.auth.currentUser!.id
          }));
      if (response.statusCode != 200) {
        throw Exception("Error getting the products, ${response.data}");
      }
      final product = ProductModel.fromJson(response.data);
      debugPrint(product.image.toString());
      return product;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("Error getting the product, $e");
    }
  }

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await Dio().get("http://localhost:4003/api/product/get",
          options: Options(headers: {
            "APIKEY": API_KEY,
            "user": supabase.auth.currentUser!.id
          }));
      if (response.statusCode != 200) {
        throw Exception("Error getting the products, ${response.data}");
      }
      final List<ProductModel> products =
          (response.data as List).map((e) => ProductModel.fromJson(e)).toList();
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
          .select("ecoville_user(*), *, ecoville_product_category(*)")
          .eq('userId', userId);
      final products = response.map((e) => ProductModel.fromJson(e)).toList();
      return products;
    } catch (error) {
      debugPrint(error.toString());
      throw Exception("Error getting the products, $error");
    }
  }

  @override
  Future<bool> saveProduct({required String productId}) async {
    try {
      final data = jsonEncode({
        "productId": productId,
      });
      final response = await Dio().get("http://localhost:4003/api/likes/add",
          data: data,
          options: Options(headers: {
            "APIKEY": API_KEY,
            "user": supabase.auth.currentUser!.id
          }));
      if (response.statusCode != 200) {
        throw Exception("Error saving the products, ${response.data}");
      }
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
      final response = await Dio().get("http://localhost:4003/api/product/get",
          options: Options(headers: {
            "APIKEY": API_KEY,
            "user": supabase.auth.currentUser!.id
          }));
      if (response.statusCode != 200) {
        throw Exception("Error getting the products, ${response.data}");
      }
      final List<ProductModel> products =
          (response.data as List).map((e) => ProductModel.fromJson(e)).toList();
      for (var product in products) {
        final isWithinRange =
            await _locationProvider.isWithinRadiusFromCurrentLocation(
                longitude: product.address!.lon!,
                latitude: product.address!.lat!,
                radius: NEARBY_RADIUS);
        if (isWithinRange) {
          nearbyProducts.add(product);
        }
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

      final category = response[0]['categoryId'];
      final similarResponse = await supabase
          .from(TABLE_PRODUCT)
          .select('ecoville_product_category(*), ecoville_user(*),*')
          .eq('categoryId', category)
          .neq('id', productId)
          // .ilike("name", '%${response[0]['name']}%')
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

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final _dbHelper = service<DatabaseHelper>();
      final db = await _dbHelper.init();
      final localCategory = await db.query(LOCAL_TABLE_CATEGORY);
      if (localCategory.isNotEmpty) {
        return localCategory.map((e) => CategoryModel.fromJson(e)).toList();
      } else {
        final response = await supabase.from(TABLE_CATEGORY).select();
        final categories =
            response.map((e) => CategoryModel.fromJson(e)).toList();
        categories.forEach((element) async {
          await db.insert(LOCAL_TABLE_CATEGORY, element.toJson());
        });
        return categories;
      }
    } catch (error) {
      debugPrint(error.toString());
      throw Exception("Error getting the categories, $error");
    }
  }

  @override
  Future<List<ProductModel>> searchResults({required String name}) async {
    try {
      final searchResultPage = await supabase
          .from(TABLE_PRODUCT)
          .select("ecoville_user(*), *, ecoville_product_category(*)")
          .eq('sold', false)
          .ilike("name", '%$name%')
          .limit(10);
      return searchResultPage.map((e) => ProductModel.fromJson(e)).toList();
    } catch (error) {
      debugPrint(error.toString());
      throw Exception(error);
    }
  }
}
