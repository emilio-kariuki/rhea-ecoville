import 'package:ecoville/data/local/local_database.dart';
import 'package:ecoville/data/service/service_locator.dart';
import 'package:ecoville/models/product_model.dart';
import 'package:ecoville/utilities/packages.dart';

abstract class ProductTemplate {
  Future<List<ProductModel>> getProducts();//
  Future<ProductModel> getProduct({required String id});//
  Future<List<ProductModel>> getProductsByCategory(
      {required String categoryId});
  Future<List<ProductModel>> getProductsByUser({required String userId});
  Future<bool> saveProduct({required ProductModel product});
  Future<bool> unsaveProduct({required String id});
  Future<bool> createProduct({required ProductModel product});//
  Future<bool> updateProduct({required ProductModel product});//
  Future<bool> deleteProduct({required String id});//
}

class ProductRepository extends ProductTemplate {
  final _dbHelper = service<DatabaseHelper>();
  @override
  Future<bool> createProduct({required ProductModel product}) async {
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
  Future<List<ProductModel>> getProductsByUser({required String userId}) async {
    try {
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

      await _dbHelper.insertLocalProduct(db: db, product: product);
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

      await _dbHelper.deleteLocalProduct(db: db, id: id);
      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("Error saving the product, $e");
    }
  }
}
