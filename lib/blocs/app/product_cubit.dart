import 'package:ecoville/data/provider/product_provider.dart';
import 'package:ecoville/data/service/service_locator.dart';
import 'package:ecoville/models/product_model.dart';
import 'package:ecoville/utilities/packages.dart';

class ProductCubit extends Cubit<ProductState> {
  final _productProvider = service<ProductProvider>();
  ProductCubit() : super(ProductState());

  Future<void> createProduct({required ProductModel product}) async {
    emit(state.copyWith(status: ProductStatus.loading));
    try {
      await _productProvider.createProduct(product: product);
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

  Future<void> getProducts() async {
    emit(state.copyWith(status: ProductStatus.loading));
    try {
      final products = await _productProvider.getProducts();
      emit(state.copyWith(status: ProductStatus.success, products: products));
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

  Future<void> getProductsByUser({required String userId}) async {
    emit(state.copyWith(status: ProductStatus.loading));
    try {
      final products = await _productProvider.getProductsByUser(userId: userId);
      emit(state.copyWith(status: ProductStatus.success, products: products));
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
  final ProductStatus status;
  final String message;

  ProductState({
    this.product,
    this.products = const <ProductModel>[],
    this.status = ProductStatus.initial,
    this.message = '',
  });

  ProductState copyWith({
    ProductModel? product,
    List<ProductModel>? products,
    ProductStatus? status,
    String? message,
  }) {
    return ProductState(
      product: product ?? this.product,
      products: products ?? this.products,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}
