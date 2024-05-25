import 'package:ecoville/data/provider/product_provider.dart';
import 'package:ecoville/data/service/service_locator.dart';
import 'package:ecoville/models/product_model.dart';
import 'package:ecoville/utilities/packages.dart';

class ProductCubit extends Cubit<ProductState> {
  final _productProvider = service<ProductProvider>();
  ProductCubit() : super(ProductState());

  Future<void> getProducts() async {
    emit(state.copyWith(status: ProductStatus.loading));
    try {
      final products = await _productProvider.getProducts();
            debugPrint("Products: $products");
      emit(state.copyWith(
        status: ProductStatus.success,
        products: products,
      ));
    } catch (e) {
      emit(
          state.copyWith(status: ProductStatus.success, message: e.toString()));
    }
  }

  Future<void> getProduct({required String id}) async {
    emit(state.copyWith(status: ProductStatus.loading));
    try {
      final product = await _productProvider.getProduct(id: id);
      emit(state.copyWith(status: ProductStatus.success, product: product));
    } catch (e) {
      emit(
          state.copyWith(status: ProductStatus.success, message: e.toString()));
    }
  }

  Future<void> getProductsByCategory({required String categoryId}) async {
    emit(state.copyWith(status: ProductStatus.loading));
    try {
      final products =
          await _productProvider.getProductsByCategory(categoryId: categoryId);
      emit(state.copyWith(status: ProductStatus.success, products: products));
    } catch (e) {
      emit(
          state.copyWith(status: ProductStatus.success, message: e.toString()));
    }
  }

  Future<void> getUserProductsPosted() async {
    emit(state.copyWith(status: ProductStatus.loading));
    try {
      final products = await _productProvider.getUserProductsPosted();
      emit(state.copyWith(status: ProductStatus.success, products: products));
    } catch (e) {
      emit(
          state.copyWith(status: ProductStatus.success, message: e.toString()));
    }
  }

  Future<void> createProduct(
      {required ProductModel product, required bool allowBidding}) async {
    emit(state.copyWith(status: ProductStatus.loading));
    try {
      await _productProvider.createProduct(
          product: product, allowBidding: allowBidding);
      emit(state.copyWith(status: ProductStatus.success));
    } catch (e) {
      emit(
          state.copyWith(status: ProductStatus.success, message: e.toString()));
    }
  }

  Future<void> updateProduct({required ProductModel product}) async {
    emit(state.copyWith(status: ProductStatus.loading));
    try {
      await _productProvider.updateProduct(product: product);
      emit(state.copyWith(status: ProductStatus.success));
    } catch (e) {
      emit(
          state.copyWith(status: ProductStatus.success, message: e.toString()));
    }
  }

  Future<void> deleteProduct({required String id}) async {
    emit(state.copyWith(status: ProductStatus.loading));
    try {
      await _productProvider.deleteProduct(id: id);
      emit(state.copyWith(status: ProductStatus.success));
    } catch (e) {
      emit(
          state.copyWith(status: ProductStatus.success, message: e.toString()));
    }
  }

  Future<void> saveProduct({required ProductModel product}) async {
    emit(state.copyWith(status: ProductStatus.loading));
    try {
      await _productProvider.saveProduct(product: product);
      final savedProducts = await _productProvider.getSavedProducts();
      emit(state.copyWith(
          status: ProductStatus.success, savedProducts: savedProducts));
    } catch (e) {
      emit(
          state.copyWith(status: ProductStatus.success, message: e.toString()));
    }
  }

  Future<void> getSavedProducts() async {
    emit(state.copyWith(status: ProductStatus.loading));
    try {
      final savedProducts = await _productProvider.getSavedProducts();
      emit(state.copyWith(
          status: ProductStatus.success, savedProducts: savedProducts));
    } catch (e) {
      emit(
          state.copyWith(status: ProductStatus.success, message: e.toString()));
    }
  }

  Future<void> unsaveProduct({required String id}) async {
    emit(state.copyWith(status: ProductStatus.loading));
    try {
      await _productProvider.unsaveProduct(id: id);
      emit(state.copyWith(status: ProductStatus.success));
    } catch (e) {
      emit(
          state.copyWith(status: ProductStatus.success, message: e.toString()));
    }
  }

  Future<void> watchProduct({required ProductModel product}) async {
    emit(state.copyWith(status: ProductStatus.loading));
    try {
      await _productProvider.watchProduct(product: product);
      emit(state.copyWith(status: ProductStatus.success));
    } catch (e) {
      emit(
          state.copyWith(status: ProductStatus.success, message: e.toString()));
    }
  }

  Future<void> unwatchProduct({required String id}) async {
    emit(state.copyWith(status: ProductStatus.loading));
    try {
      await _productProvider.unwatchProduct(id: id);
      emit(state.copyWith(status: ProductStatus.success));
    } catch (e) {
      emit(
          state.copyWith(status: ProductStatus.success, message: e.toString()));
    }
  }

  Future<void> getWatchedProducts() async {
    emit(state.copyWith(status: ProductStatus.loading));
    try {
      final watchedProducts = await _productProvider.getWatchedProducts();
      emit(state.copyWith(
          status: ProductStatus.success, watchedProducts: watchedProducts));
    } catch (e) {
      emit(
          state.copyWith(status: ProductStatus.success, message: e.toString()));
    }
  }

  Future<void> getNearbyProducts() async {
    emit(state.copyWith(status: ProductStatus.loading));
    try {
      final productsNearby = await _productProvider.getNearbyProducts();
      emit(state.copyWith(
          status: ProductStatus.success, productsNearby: productsNearby));
    } catch (e) {
      emit(
          state.copyWith(status: ProductStatus.success, message: e.toString()));
    }
  }

  Future<void> getSimilarProducts({required String productId}) async {
    emit(state.copyWith(status: ProductStatus.loading));
    try {
      final similarProducts =
          await _productProvider.getSimilarProducts(productId: productId);
      emit(state.copyWith(
          status: ProductStatus.success, similarProducts: similarProducts));
    } catch (e) {
      emit(
          state.copyWith(status: ProductStatus.success, message: e.toString()));
    }
  }
}

enum ProductStatus { initial, created, updated, loading, success }

class ProductState {
  final ProductModel? product;
  final List<ProductModel> products;
  final List<ProductModel> productsNearby;
  final List<ProductModel> savedProducts;
  final List<ProductModel> similarProducts;
  final List<ProductModel> watchedProducts;
  final ProductStatus status;
  final String message;

  ProductState({
    this.product,
    this.products = const <ProductModel>[],
    this.productsNearby = const <ProductModel>[],
    this.savedProducts = const <ProductModel>[],
    this.similarProducts = const <ProductModel>[],
    this.watchedProducts = const <ProductModel>[],
    this.status = ProductStatus.initial,
    this.message = '',
  });

  ProductState copyWith({
    ProductModel? product,
    List<ProductModel>? products,
    List<ProductModel>? productsNearby,
    List<ProductModel>? savedProducts,
    List<ProductModel>? similarProducts,
    List<ProductModel>? watchedProducts,
    ProductStatus? status,
    String? message,
  }) {
    return ProductState(
      product: product ?? this.product,
      products: products ?? this.products,
      productsNearby: productsNearby ?? this.productsNearby,
      savedProducts: savedProducts ?? this.savedProducts,
      similarProducts: similarProducts ?? this.similarProducts,
      watchedProducts: watchedProducts ?? this.watchedProducts,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}
