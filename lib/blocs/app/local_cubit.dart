import 'package:ecoville/data/provider/product_provider.dart';
import 'package:ecoville/data/service/service_locator.dart';
import 'package:ecoville/models/product_model.dart';
import 'package:ecoville/utilities/packages.dart';

class LocalCubit extends Cubit<LocalState> {
  final _productProvider = service<ProductProvider>();
  LocalCubit() : super(LocalState());

  Future<void> saveProduct({required ProductModel product}) async {
    try {
      emit(state.copyWith(status: LocalStatus.loading));
      await _productProvider.saveProduct(product: product);
      emit(state.copyWith(
        status: LocalStatus.success,
        message: "Product saved successfully",
      ));
    } catch (error) {
      emit(state.copyWith(
        status: LocalStatus.success,
        message: error.toString(),
      ));
    }
  }

  Future<void> getSavedProduct() async {
    try {
      emit(state.copyWith(status: LocalStatus.loading));
      final savedProducts = await _productProvider.getSavedProducts();
      emit(state.copyWith(
        status: LocalStatus.success,
        savedProducts: savedProducts,
        message: "Product saved successfully",
      ));
    } catch (error) {
      emit(state.copyWith(
        status: LocalStatus.success,
        message: error.toString(),
      ));
    }
  }

  Future<void> removeProduct({required String id}) async {
    try {
      emit(state.copyWith(status: LocalStatus.loading));
      await _productProvider.unsaveProduct(id: id);
      final savedProducts = await _productProvider.getSavedProducts();
      emit(state.copyWith(
        status: LocalStatus.success,
        savedProducts: savedProducts,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: LocalStatus.success,
        message: error.toString(),
      ));
    }
  }

  Future<void> watchProduct({required ProductModel product}) async {
    try {
      emit(state.copyWith(status: LocalStatus.loading));
      await _productProvider.watchProduct(product: product);
      emit(state.copyWith(
        status: LocalStatus.success,
        message: "Product saved successfully",
      ));
    } catch (error) {
      emit(state.copyWith(
        status: LocalStatus.success,
        message: error.toString(),
      ));
    }
  }

  Future<void> getWatchedProduct() async {
    try {
      emit(state.copyWith(status: LocalStatus.loading));
      final watchedProducts = await _productProvider.getWatchedProducts();
      emit(state.copyWith(
        status: LocalStatus.success,
        watchedProducts: watchedProducts,
        message: "Product saved successfully",
      ));
    } catch (error) {
      emit(state.copyWith(
        status: LocalStatus.success,
        message: error.toString(),
      ));
    }
  }

  Future<void> unwatchProduct({required String id}) async {
    try {
      emit(state.copyWith(status: LocalStatus.loading));
      await _productProvider.unwatchProduct(id: id);
      final watchedProducts = await _productProvider.getWatchedProducts();
      emit(state.copyWith(
        status: LocalStatus.success,
        watchedProducts: watchedProducts,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: LocalStatus.success,
        message: error.toString(),
      ));
    }
  }
}

enum LocalStatus { initial, loading, success }

class LocalState {
  final LocalStatus status;
  final List<ProductModel> savedProducts;
  final List<ProductModel> watchedProducts;
  final String message;

  LocalState({
    this.status = LocalStatus.initial,
    this.savedProducts = const [],
    this.watchedProducts = const [],
    this.message = '',
  });

  LocalState copyWith({
    LocalStatus? status,
    List<ProductModel>? savedProducts,
    List<ProductModel>? watchedProducts,
    String? message,
  }) {
    return LocalState(
      status: status ?? this.status,
      savedProducts: savedProducts ?? this.savedProducts,
      watchedProducts: watchedProducts ?? this.watchedProducts,
      message: message ?? this.message,
    );
  }
}
