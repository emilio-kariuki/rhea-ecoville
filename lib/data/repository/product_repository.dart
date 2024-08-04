import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ecoville/data/local/local_database.dart';
import 'package:ecoville/data/provider/location_provider.dart';
import 'package:ecoville/data/service/service_locator.dart';
import 'package:ecoville/main.dart';
import 'package:ecoville/models/category_model.dart';
import 'package:ecoville/models/interactions_model.dart';
import 'package:ecoville/models/local_product_model.dart';
import 'package:ecoville/models/product_model.dart';
import 'package:ecoville/models/product_request_model.dart';
import 'package:ecoville/models/recommendation_model.dart';
import 'package:ecoville/utilities/packages.dart';

abstract class ProductTemplate {
  Future<List<ProductModel>> getProducts();
  Future<List<ProductModel>> getBiddingProducts();
  Future<ProductModel> getProduct({required String id});
  Future<List<ProductModel>> getProductsByCategory(
      {required String categoryId});
  Future<List<ProductModel>> getProductsBySeller({required String sellerId});
  Future<List<ProductModel>> getUserProductsPosted();
  Future<bool> createProduct(
      {required ProductRequestModel product, required bool allowBidding});
  Future<bool> updateProduct({required ProductModel product});
  Future<bool> deleteProduct({required String id});

  //* saved products
  Future<bool> saveProduct({required String productId});
  Future<List<InteractionsModel>> getSavedProducts();
  Future<bool> unsaveProduct({required String id});

  //* watch product
  Future<bool> watchProduct({required LocalProductModel product});
  Future<bool> unwatchProduct({required String id});
  Future<List<LocalProductModel>> getWatchedProducts();

  //* product wishlist
  Future<bool> addProductToWishlist({required String id});
  Future<List<InteractionsModel>> getWishlistProducts();
  Future<bool> removeFromWishlist({required String id});

  //* Nearby products
  Future<List<ProductModel>> getNearbyProducts();
  Future<List<ProductModel>> getSimilarProducts({required String productId});

  //* Like products
  Future<bool> likeProduct({required String id});
  Future<bool> unlikeProduct({required String id});
  Future<List<InteractionsModel>> getLikedProducts();

  Future<List<CategoryModel>> getCategories();
  Future<List<ProductModel>> searchResults({
    required String query,
  });
  Future<List<RecommendationModel>> getRecommendations({required String query});
}

class ProductRepository extends ProductTemplate {
  final _dbHelper = service<DatabaseHelper>();
  final _locationProvider = service<LocationProvider>();

  @override
  Future<bool> createProduct(
      {required ProductRequestModel product,
      required bool allowBidding}) async {
    try {
      logger.d(product.toJson());
      final request = jsonEncode(product.toJson());
      final response = await Dio().post("$API_URL/product/create",
          data: request,
          options: Options(headers: {
            "APIKEY": API_KEY,
            "user": supabase.auth.currentUser!.id
          }));
      if (response.statusCode != 200) {
        throw Exception("Error getting the products, ${response.data}");
      }
      return true;
    } catch (error) {
      debugPrint(error.toString());
      throw Exception("Error getting the products, $error");
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
      final response = await Dio().get("$API_URL/product/get/$id",
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
      final response = await Dio().get("$API_URL/product/get",
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
      final response = await Dio().get("$API_URL/product/sellerProducts",
          options: Options(headers: {
            "APIKEY": API_KEY,
            "user": supabase.auth.currentUser!.id
          }));
      debugPrint(response.data.toString());
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
  Future<bool> saveProduct({required String productId}) async {
    try {
      final data = jsonEncode({
        "productId": productId,
      });
      final response = await Dio().post("$API_URL/saved/add",
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
      final request = jsonEncode({
        "productId": id,
      });
      final response = await Dio().post("$API_URL/saved/remove",
          data: request,
          options: Options(headers: {
            "APIKEY": API_KEY,
            "user": supabase.auth.currentUser!.id
          }));
      if (response.statusCode != 200) {
        throw Exception("Error liking the products, ${response.data}");
      }
      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("Error liking the product, $e");
    }
  }

  @override
  Future<List<InteractionsModel>> getSavedProducts() async {
    try {
      final userId = supabase.auth.currentUser!.id;
      final response = await Dio().get("$API_URL/saved/user/$userId",
          options: Options(headers: {
            "APIKEY": API_KEY,
            "user": supabase.auth.currentUser!.id
          }));
      logger.d(response);
      if (response.statusCode != 200) {
        throw Exception("Error liking the products, ${response.data}");
      }
      final List<InteractionsModel> products = (response.data as List)
          .map((e) => InteractionsModel.fromJson(e))
          .toList();
      return products;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("Error liking the product, $e");
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
      final response = await Dio().get("$API_URL/product/get",
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
                longitude:
                    double.tryParse(product.address?.lon ?? "0.0") ?? 0.0,
                latitude: double.tryParse(product.address?.lat ?? "0.0") ?? 0.0,
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
  Future<bool> addProductToWishlist({required String id}) async {
    try {
      final request = jsonEncode({
        "productId": id,
      });
      final response = await Dio().post("$API_URL/wishlist/add",
          data: request,
          options: Options(headers: {
            "APIKEY": API_KEY,
            "user": supabase.auth.currentUser!.id
          }));
      if (response.statusCode != 200) {
        throw Exception("Error liking the products, ${response.data}");
      }
      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("Error liking the product, $e");
    }
  }

  @override
  Future<List<InteractionsModel>> getWishlistProducts() async {
    try {
      final userId = supabase.auth.currentUser!.id;
      final response = await Dio().get("$API_URL/wishlist/user/$userId",
          options: Options(headers: {
            "APIKEY": API_KEY,
            "user": supabase.auth.currentUser!.id
          }));
      if (response.statusCode != 200) {
        throw Exception("Error liking the products, ${response.data}");
      }
      final List<InteractionsModel> products = (response.data as List)
          .map((e) => InteractionsModel.fromJson(e))
          .toList();
      return products;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("Error liking the product, $e");
    }
  }

  @override
  Future<List<InteractionsModel>> getLikedProducts() async {
    try {
      final userId = supabase.auth.currentUser!.id;
      final response = await Dio().get("$API_URL/likes/user/$userId",
          options: Options(headers: {
            "APIKEY": API_KEY,
            "user": supabase.auth.currentUser!.id
          }));
      logger.d(response);
      if (response.statusCode != 200) {
        throw Exception("Error liking the products, ${response.data}");
      }
      final List<InteractionsModel> products = (response.data as List)
          .map((e) => InteractionsModel.fromJson(e))
          .toList();
      return products;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("Error liking the product, $e");
    }
  }

  @override
  Future<bool> likeProduct({required String id}) async {
    try {
      final request = jsonEncode({
        "productId": id,
      });
      final response = await Dio().post("$API_URL/likes/add",
          data: request,
          options: Options(headers: {
            "APIKEY": API_KEY,
            "user": supabase.auth.currentUser!.id
          }));
      if (response.statusCode != 200) {
        throw Exception("Error liking the products, ${response.data}");
      }
      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("Error liking the product, $e");
    }
  }

  @override
  Future<bool> unlikeProduct({required String id}) async {
    try {
      final request = jsonEncode({
        "productId": id,
      });
      final response = await Dio().post("$API_URL/likes/remove",
          data: request,
          options: Options(headers: {
            "APIKEY": API_KEY,
            "user": supabase.auth.currentUser!.id
          }));
      if (response.statusCode != 200) {
        throw Exception("Error liking the products, ${response.data}");
      }
      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("Error liking the product, $e");
    }
  }

  @override
  Future<bool> removeFromWishlist({required String id}) async {
    try {
      final request = jsonEncode({
        "productId": id,
      });
      final response = await Dio().post("$API_URL/wishlist/remove",
          data: request,
          options: Options(headers: {
            "APIKEY": API_KEY,
            "user": supabase.auth.currentUser!.id
          }));
      if (response.statusCode != 200) {
        throw Exception("Error liking the products, ${response.data}");
      }
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
        final response = await Dio().get("$API_URL/categories",
            options: Options(headers: {
              "APIKEY": API_KEY,
              "user": supabase.auth.currentUser!.id
            }));
        if (response.statusCode != 200) {
          throw Exception("Error liking the products, ${response.data}");
        }
        final List<CategoryModel> categories = (response.data as List)
            .map((e) => CategoryModel.fromJson(e))
            .toList();
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
  Future<List<ProductModel>> searchResults({required String query}) async {
    try {
      final queries = <String, String>{};
      final parts = query.split('&&');
      for (var part in parts) {
        if (part.contains('=')) {
          final keyValue = part.split('=');
          if (keyValue.length == 2) {
            queries[keyValue[0]] = keyValue[1];
          }
        } else {
          queries['name'] = part;
        }
      }
      final response = await Dio().get(
          "$API_URL/product/get?${Uri(queryParameters: queries).query}",
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
      throw Exception(error);
    }
  }

  @override
  Future<List<RecommendationModel>> getRecommendations(
      {required String query}) async {
    try {
      final request = jsonEncode({"query": query});
      final response = await Dio().get("$API_URL/ai/product/recommendations",
          data: request,
          options: Options(headers: {
            "APIKEY": API_KEY,
          }));
      if (response.statusCode != 200) {
        throw Exception("Error getting the products, ${response.data}");
      }
      final List<RecommendationModel> products = (response.data as List)
          .map((e) => RecommendationModel.fromJson(e))
          .toList();
      return products;
    } catch (error) {
      debugPrint(error.toString());
      throw Exception("Error getting the recommendations, $error");
    }
  }

  @override
  Future<List<ProductModel>> getProductsBySeller(
      {required String sellerId}) async {
    try {
      final response = await Dio().get("$API_URL/product/sellerProducts",
          options: Options(headers: {"APIKEY": API_KEY, "user": sellerId}));
      debugPrint(response.data.toString());
      if (response.statusCode != 200) {
        throw Exception("Error getting the products, ${response.data}");
      }
      final List<ProductModel> products =
          (response.data as List).map((e) => ProductModel.fromJson(e)).toList();
      final sellerProducts =
          products.where((element) => element.userId == sellerId).toList();
      return sellerProducts;
    } catch (error) {
      debugPrint(error.toString());
      throw Exception("Error getting the products, $error");
    }
  }
  
  @override
  Future<List<ProductModel>> getBiddingProducts() async{
    try {
      final response = await Dio().get("$API_URL/product/get?allowBidding=true",
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
}
