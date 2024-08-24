import 'package:ecoville/data/repository/product_repository.dart';
import 'package:ecoville/models/category_model.dart';
import 'package:ecoville/models/interactions_model.dart';
import 'package:ecoville/models/local_product_model.dart';
import 'package:ecoville/models/product_model.dart';
import 'package:ecoville/models/product_request_model.dart';
import 'package:ecoville/models/recommendation_model.dart';

class ProductProvider extends ProductTemplate {
  final ProductRepository _productRepository;
  ProductProvider({required ProductRepository productRepository})
      : _productRepository = productRepository;

  @override
  Future<bool> createProduct(
      {required ProductRequestModel product, required bool allowBidding}) {
    return _productRepository.createProduct(
        product: product, allowBidding: allowBidding);
  }

  @override
  Future<bool> deleteProduct({required String id}) {
    return _productRepository.deleteProduct(id: id);
  }

  @override
  Future<ProductModel> getProduct({required String id}) {
    return _productRepository.getProduct(id: id);
  }

  @override
  Future<List<ProductModel>> getProducts() {
    return _productRepository.getProducts();
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(
      {required String categoryId}) {
    return _productRepository.getProductsByCategory(categoryId: categoryId);
  }

  @override
  Future<List<ProductModel>> getUserProductsPosted() {
    return _productRepository.getUserProductsPosted();
  }

  @override
  Future<bool> saveProduct({required String productId}) {
    return _productRepository.saveProduct(productId: productId);
  }

  @override
  Future<bool> unsaveProduct({required String id}) {
    return _productRepository.unsaveProduct(id: id);
  }

  @override
  Future<bool> updateProduct({required Map<String,dynamic> product}) {
    return _productRepository.updateProduct(product: product);
  }

  @override
  Future<List<InteractionsModel>> getSavedProducts() {
    return _productRepository.getSavedProducts();
  }

  @override
  Future<bool> watchProduct({required LocalProductModel product}) {
    return _productRepository.watchProduct(product: product);
  }

  @override
  Future<List<LocalProductModel>> getWatchedProducts() {
    return _productRepository.getWatchedProducts();
  }

  @override
  Future<bool> unwatchProduct({required String id}) {
    return _productRepository.unwatchProduct(id: id);
  }

  @override
  Future<List<ProductModel>> getNearbyProducts() {
    return _productRepository.getNearbyProducts();
  }

  @override
  Future<List<ProductModel>> getSimilarProducts({required String productId}) {
    return _productRepository.getSimilarProducts(productId: productId);
  }

  @override
  Future<bool> addProductToWishlist({required String id}) {
    return _productRepository.addProductToWishlist(id: id);
  }

  @override
  Future<List<InteractionsModel>> getWishlistProducts() {
    return _productRepository.getWishlistProducts();
  }

  @override
  Future<List<InteractionsModel>> getLikedProducts() {
    return _productRepository.getLikedProducts();
  }

  @override
  Future<bool> likeProduct({required String id}) {
    return _productRepository.likeProduct(id: id);
  }

  @override
  Future<bool> unlikeProduct({required String id}) {
    return _productRepository.unlikeProduct(id: id);
  }

  @override
  Future<bool> removeFromWishlist({required String id}) {
    return _productRepository.removeFromWishlist(id: id);
  }

  @override
  Future<List<CategoryModel>> getCategories() {
    return _productRepository.getCategories();
  }

  @override
  Future<List<ProductModel>> searchResults({required String query}) {
    return _productRepository.searchResults(
      query: query,
    );
  }

  @override
  Future<List<RecommendationModel>> getRecommendations({required String query}) {
    return _productRepository.getRecommendations(query: query);
  }
  
  @override
  Future<List<ProductModel>> getProductsBySeller({required String sellerId}) {
    return _productRepository.getProductsBySeller(sellerId: sellerId);
  }
  
  @override
  Future<List<ProductModel>> getBiddingProducts() {
    return _productRepository.getBiddingProducts();
  }
}
