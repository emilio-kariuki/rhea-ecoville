import 'package:ecoville/data/provider/product_provider.dart';
import 'package:ecoville/data/service/service_locator.dart';
import 'package:ecoville/models/category_model.dart';
import 'package:ecoville/models/interactions_model.dart';
import 'package:ecoville/models/local_product_model.dart';
import 'package:ecoville/models/product_model.dart';
import 'package:ecoville/models/product_request_model.dart';
import 'package:ecoville/models/recommendation_model.dart';
import 'package:ecoville/utilities/packages.dart';

class ProductCubit extends Cubit<ProductState> {
  final _productProvider = service<ProductProvider>();
  ProductCubit() : super(ProductState());

  void setLoading() => emit(state.copyWith(status: ProductStatus.loading));
  void rebuild() => emit(state.copyWith(status: ProductStatus.success));
  void setError(String message) =>
      emit(state.copyWith(status: ProductStatus.success, message: message));

  Future<void> getProducts() async {
    setLoading();
    try {
      final products = await _productProvider.getProducts();
      emit(state.copyWith(
        status: ProductStatus.success,
        products: products,
      ));
    } catch (e) {
      emit(state.copyWith(status: ProductStatus.error, message: e.toString()));
    }
  }

  Future<void> getBiddingProducts() async {
    setLoading();
    try {
      final biddingProducts = await _productProvider.getBiddingProducts();
      emit(state.copyWith(
        status: ProductStatus.success,
        biddingProducts: biddingProducts,
      ));
    } catch (e) {
      emit(state.copyWith(status: ProductStatus.error, message: e.toString()));
    }
  }

  Future<void> getProduct({required String id}) async {
    setLoading();
    try {
      final product = await _productProvider.getProduct(id: id);
      emit(state.copyWith(status: ProductStatus.success, product: product));
    } catch (e) {
      emit(state.copyWith(status: ProductStatus.error, message: e.toString()));
    }
  }

  Future<void> getProductsByCategory({required String categoryId}) async {
    setLoading();
    try {
      final products =
          await _productProvider.getProductsByCategory(categoryId: categoryId);
      emit(state.copyWith(status: ProductStatus.success, products: products));
    } catch (e) {
      emit(state.copyWith(status: ProductStatus.error, message: e.toString()));
    }
  }

  Future<void> getUserProductsPosted() async {
    setLoading();
    try {
      final products = await _productProvider.getUserProductsPosted();
      emit(state.copyWith(status: ProductStatus.success, products: products));
    } catch (e) {
      emit(state.copyWith(status: ProductStatus.error, message: e.toString()));
    }
  }

  Future<void> createProduct(
      {required ProductRequestModel product, required bool allowBidding}) async {
    setLoading();
    try {
      await _productProvider.createProduct(
          product: product, allowBidding: allowBidding);
      emit(state.copyWith(status: ProductStatus.success, message: "product created successfully"));
    } catch (e) {
      emit(state.copyWith(status: ProductStatus.error, message: e.toString()));
    }
  }

  Future<void> updateProduct({required Map<String,dynamic> product}) async {
    setLoading();
    try {
      await _productProvider.updateProduct(product: product);
      emit(state.copyWith(status: ProductStatus.updated));
    } catch (e) {
      emit(state.copyWith(status: ProductStatus.error, message: e.toString()));
    }
  }

  Future<void> deleteProduct({required String id}) async {
    setLoading();
    try {
      await _productProvider.deleteProduct(id: id);
      emit(state.copyWith(status: ProductStatus.success));
    } catch (e) {
      emit(state.copyWith(status: ProductStatus.error, message: e.toString()));
    }
  }

  Future<void> saveProduct({required String productId}) async {
    setLoading();
    try {
      await _productProvider.saveProduct(productId: productId);
      final savedProducts = await _productProvider.getSavedProducts();
      emit(state.copyWith(
          status: ProductStatus.success, savedProducts: savedProducts));
    } catch (e) {
      emit(state.copyWith(status: ProductStatus.error, message: e.toString()));
    }
  }

  Future<void> getSavedProducts() async {
    setLoading();
    try {
      final savedProducts = await _productProvider.getSavedProducts();
      emit(state.copyWith(
          status: ProductStatus.success, savedProducts: savedProducts));
    } catch (e) {
      emit(state.copyWith(status: ProductStatus.error, message: e.toString()));
    }
  }

  Future<void> unsaveProduct({required String id}) async {
    setLoading();
    try {
      await _productProvider.unsaveProduct(id: id);
      emit(state.copyWith(status: ProductStatus.success));
    } catch (e) {
      emit(state.copyWith(status: ProductStatus.error, message: e.toString()));
    }
  }

  Future<void> watchProduct({required LocalProductModel product}) async {
    setLoading();
    try {
      await _productProvider.watchProduct(product: product);
      emit(state.copyWith(status: ProductStatus.success));
    } catch (e) {
      emit(state.copyWith(status: ProductStatus.error, message: e.toString()));
    }
  }

  Future<void> unwatchProduct({required String id}) async {
    setLoading();
    try {
      await _productProvider.unwatchProduct(id: id);
      emit(state.copyWith(status: ProductStatus.success));
    } catch (e) {
      emit(state.copyWith(status: ProductStatus.error, message: e.toString()));
    }
  }

  Future<void> getWatchedProducts() async {
    setLoading();
    try {
      final watchedProducts = await _productProvider.getWatchedProducts();
      emit(state.copyWith(
          status: ProductStatus.success, watchedProducts: watchedProducts));
    } catch (e) {
      emit(state.copyWith(status: ProductStatus.error, message: e.toString()));
    }
  }

  Future<void> getNearbyProducts() async {
    setLoading();
    try {
      final productsNearby = await _productProvider.getNearbyProducts();
      emit(state.copyWith(
          status: ProductStatus.success, productsNearby: productsNearby));
    } catch (e) {
      emit(state.copyWith(status: ProductStatus.error, message: e.toString()));
    }
  }

  Future<void> getSimilarProducts({required String productId}) async {
    setLoading();
    try {
      final similarProducts =
          await _productProvider.getSimilarProducts(productId: productId);
      debugPrint("similar products are $similarProducts");
      emit(state.copyWith(
          status: ProductStatus.success, similarProducts: similarProducts));
    } catch (e) {
      emit(state.copyWith(status: ProductStatus.error, message: e.toString()));
    }
  }

  Future<void> getCategories() async {
    setLoading();
    try {
      final categories = await _productProvider.getCategories();
      emit(state.copyWith(
          status: ProductStatus.success, categories: categories));
    } catch (e) {
      emit(state.copyWith(status: ProductStatus.error, message: e.toString()));
    }
  }

  Future<void> getSearchResults({required String query}) async {
    try {
      setLoading();
      final searchResults = await _productProvider.searchResults(query: query);
      debugPrint("search results: $searchResults");
      emit(state.copyWith(
          status: ProductStatus.success, searchResults: searchResults));
    } catch (error) {
      setError(error.toString());
    }
  }

  Future<void> getProductRecommendations({required String query}) async {
    try {
      setLoading();
      final recommendations =
          await _productProvider.getRecommendations(query: query);
      emit(state.copyWith(
          status: ProductStatus.success, recommendations: recommendations));
    } catch (error) {
      setError(error.toString());
    }
  }

  Future<void> getSellerProducts({required String sellerId}) async {
    try {
      setLoading();
      final sellerProducts = await _productProvider.getProductsBySeller(sellerId: sellerId);
      emit(state.copyWith(
          status: ProductStatus.success, sellerProducts: sellerProducts));
    } catch (error) {
      setError(error.toString());
    }
  }
}

enum ProductStatus { initial, created, updated, loading, success, error }

class ProductState {
  final ProductModel? product;
  final List<ProductModel> products;
  final List<ProductModel> biddingProducts;
  final List<ProductModel> productsNearby;
  final List<InteractionsModel> savedProducts;
  final List<ProductModel> similarProducts;
  final List<ProductModel> searchResults;
  final List<LocalProductModel> watchedProducts;
  final List<RecommendationModel> recommendations;
  final List<ProductModel> sellerProducts;
  final List<CategoryModel> categories;
  final ProductStatus status;
  final String message;

  ProductState({
    this.product,
    this.products = const <ProductModel>[],
    this.biddingProducts = const <ProductModel>[],
    this.productsNearby = const <ProductModel>[],
    this.savedProducts = const <InteractionsModel>[],
    this.similarProducts = const <ProductModel>[],
    this.searchResults = const <ProductModel>[],
    this.watchedProducts = const <LocalProductModel>[],
    this.categories = const <CategoryModel>[],
    this.recommendations = const <RecommendationModel>[],
    this.sellerProducts = const <ProductModel>[],
    this.status = ProductStatus.initial,
    this.message = '',
  });

  ProductState copyWith({
    ProductModel? product,
    List<ProductModel>? products,
    List<ProductModel>? biddingProducts,
    List<ProductModel>? productsNearby,
    List<InteractionsModel>? savedProducts,
    List<ProductModel>? similarProducts,
    List<ProductModel>? searchResults,
    List<LocalProductModel>? watchedProducts,
    List<CategoryModel>? categories,
    List<RecommendationModel>? recommendations,
    List<ProductModel>? sellerProducts,
    ProductStatus? status,
    String? message,
  }) {
    return ProductState(
      product: product ?? this.product,
      products: products ?? this.products,
      biddingProducts: biddingProducts ?? this.biddingProducts,
      productsNearby: productsNearby ?? this.productsNearby,
      savedProducts: savedProducts ?? this.savedProducts,
      similarProducts: similarProducts ?? this.similarProducts,
      searchResults: searchResults ?? this.searchResults,
      watchedProducts: watchedProducts ?? this.watchedProducts,
      categories: categories ?? this.categories,
      recommendations: recommendations ?? this.recommendations,
      sellerProducts: sellerProducts ?? this.sellerProducts,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}
