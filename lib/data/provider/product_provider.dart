import 'package:ecoville/data/repository/product_repository.dart';
import 'package:ecoville/models/product_model.dart';

class ProductProvider extends ProductTemplate {
  final ProductRepository _productRepository;
  ProductProvider({required ProductRepository productRepository})
      : _productRepository = productRepository;

  @override
  Future<bool> createProduct({required ProductModel product, required bool allowBidding}) {
    return _productRepository.createProduct(product: product, allowBidding: allowBidding);
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
  Future<bool> saveProduct({required ProductModel product}) {
    return _productRepository.saveProduct(product: product);
  }

  @override
  Future<bool> unsaveProduct({required String id}) {
    return _productRepository.unsaveProduct(id: id);
  }

  @override
  Future<bool> updateProduct({required ProductModel product}) {
    return _productRepository.updateProduct(product: product);
  }

  @override
  Future<List<ProductModel>> getSavedProducts() {
    return _productRepository.getSavedProducts();
  }

  @override
  Future<bool> watchProduct({required ProductModel product}) {
    return _productRepository.watchProduct(product: product);
  }

  @override
  Future<List<ProductModel>> getWatchedProducts() {
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
}
