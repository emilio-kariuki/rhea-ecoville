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

abstract class ProductTemp {
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
}

class ProductRepo extends ProductTemp {
  final _dbHelper = service<DatabaseHelper>();
  final _locationProvider = service<LocationProvider>();
  @override
  Future<bool> createProduct({required ProductRequestModel product, required bool allowBidding}) async {
    try {
      await supabase.from(TABLE_PRODUCT).insert(product.toJson());
      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("ERROR");
    }
  }

  @override
  Future<bool> deleteProduct({required String id}) async {
    try {
      await supabase.from(TABLE_PRODUCT).delete().eq('id', id);
      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("Error deleting product, $e");
    }
  }

  @override
  Future<ProductModel> getProduct({required String id}) async {
    try {
      final response = await Dio().get(
        "http://localhost:4003/api/product/get/$id",
        options: Options(headers: {
          "API KEY" : API_KEY,
          "user" : supabase.auth.currentUser!.id
        }));
      if(response.statusCode != 200) {
        throw Exception("Error getting products, ${response.data}");
      }
      final product = ProductModel.fromJson(response.data);
      debugPrint(product.image.toString());
      return product;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("Error deleting product, $e");
    }
  }

  @override
  Future<List<ProductModel>> getProducts() async{ // all products
    try {
      final response = await Dio().get(
          "http://localhost:4003/api/product/get/",
          options: Options(headers: {
            "API KEY" : API_KEY,
            "user" : supabase.auth.currentUser!.id
          }));
      if(response.statusCode != 200) {
        throw Exception("Error getting products, ${response.data}");
      }
      final List<ProductModel> products = (response.data as List).map((e) => ProductModel.fromJson(e)).toList();
      return products;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("Error deleting product, $e");
    }
  }

  @override
  Future<List<ProductModel>> getProductsByCategory({required String categoryId}) async {
    try {
      final response = await supabase.from(TABLE_PRODUCT).select(
        "ecoville_user(*) * ecoville_category(*)").eq("categoryId", categoryId);
      final products = response.map((e) => ProductModel.fromJson(e)).toList();
      return products;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("Error getting product, $e");
    }
  }

  @override
  Future<List<LocalProductModel>> getSavedProducts() async {
    try{
      final db = await _dbHelper.init();
      final savedProducts = await _dbHelper.getUserLocalProducts(db: db, table: LOCAL_TABLE_PRODUCT_SAVED);
      return savedProducts;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("Error getting product, $e");
    }
  }

  @override
  Future<List<ProductModel>> getUserProductsPosted() {
    // TODO: implement getUserProductsPosted
    throw UnimplementedError();
  }

  @override
  Future<bool> saveProduct({required String productId}) async {
    try {
      final prod = jsonEncode({
        "productId" : productId
      });
      final reply = await Dio().get("http://localhost:4003/api/likes/add",
        data: prod,
        options: Options(headers: {
          "API KEY" : API_KEY,
          "user" : supabase.auth.currentUser!.id
        }));
      if(reply.statusCode != 200) {
        throw Exception("Unable to save, ${reply.data}");
      }
      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("Error deleting product, $e");
    }
  }

  @override
  Future<bool> unsaveProduct({required String id}) async {
    final db = await _dbHelper.init();
    try {
      await _dbHelper.deleteLocalProduct(db: db, id: id, table: LOCAL_TABLE_PRODUCT_SAVED);
      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("Error deleting product, $e");
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
  Future<bool> updateProduct({required ProductModel product}) async {
    try {
      await supabase.from(TABLE_PRODUCT).update(product.toJson()).eq('id', product.id);
      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("Error saving product, $e");
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

}