import 'package:ecoville/data/repository/product_repository.dart';
import 'package:ecoville/models/category_model.dart';
import 'package:ecoville/models/interactions_model.dart';
import 'package:ecoville/models/local_product_model.dart';
import 'package:ecoville/models/product_model.dart';
import 'package:ecoville/models/product_request_model.dart';

import '../repository/product_repo.dart';

class ProductProv extends ProductTemp{
  final ProductRepo _productRepo;
  ProductProv({required ProductRepo productRepo})
  : _productRepo = productRepo;

  @override
  Future<bool> createProduct({required ProductRequestModel product, required bool allowBidding}) {
    return _productRepo.createProduct(product: product, allowBidding: allowBidding);
  }
  @override
  Future<bool> deleteProduct({required String id}) {
    return _productRepo.deleteProduct(id: id);
  }
  @override
  Future<ProductModel> getProduct({required String id}) {
    return _productRepo.getProduct(id: id);
  }
  @override
  Future<List<ProductModel>> getProducts() {
    return _productRepo.getProducts();
  }
  @override
  Future<List<ProductModel>> getProductsByCategory({required String categoryId}) {
    return _productRepo.getProductsByCategory(categoryId: categoryId);
  }
  @override
  Future<List<InteractionsModel>> getSavedProducts() {
    return _productRepo.getSavedProducts();
  }
  @override
  Future<List<ProductModel>> getUserProductsPosted() {
    return _productRepo.getUserProductsPosted();
  }
  @override
  Future<bool> saveProduct({required String productId}) {
    return _productRepo.saveProduct(productId: productId);
  }
  @override
  Future<bool> unsaveProduct({required String id}) {
    return _productRepo.unsaveProduct(id: id);
  }
  @override
  Future<bool> unwatchProduct({required String id}) {
    return _productRepo.unwatchProduct(id: id);
  }
  @override
  Future<bool> updateProduct({required ProductModel product}) {
    return _productRepo.updateProduct(product: product);
  }
  @override
  Future<bool> watchProduct({required LocalProductModel product}) {
    return _productRepo.watchProduct(product: product);
  }
  @override
  Future<List<ProductModel>> getBiddingProducts() {
    return _productRepo.getBiddingProducts();
  }
  @override
  Future<List<ProductModel>> getProductsBySeller({required String sellerId}) {
    return _productRepo.getProductsBySeller(sellerId: sellerId);
  }
}