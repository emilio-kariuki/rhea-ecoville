import 'package:ecoville/data/provider/cart_provider.dart';
import 'package:ecoville/data/provider/product_provider.dart';
import 'package:ecoville/data/service/service_locator.dart';
import 'package:ecoville/models/local_product_model.dart';
import 'package:ecoville/utilities/packages.dart';

class LocalCubit extends Cubit<LocalState> {
  final _productProvider = service<ProductProvider>();
  final _cartProvider = service<CartProvider>();

  LocalCubit() : super(LocalState());


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

  Future<void> watchProduct({required LocalProductModel product}) async {
    try {
      emit(state.copyWith(status: LocalStatus.loading));
      await _productProvider.watchProduct(product: product);
      emit(state.copyWith(
        status: LocalStatus.success,
        message: "Product watched successfully",
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

  Future<void> getWishlistProducts() async {
    try {
      emit(state.copyWith(status: LocalStatus.loading));
      final wishlistProducts = await _productProvider.getWishlistProducts();
      emit(state.copyWith(
        status: LocalStatus.success,
        wishlistProducts: wishlistProducts,
        message: "Product saved successfully",
      ));
    } catch (error) {
      emit(state.copyWith(
        status: LocalStatus.success,
        message: error.toString(),
      ));
    }
  }

  Future<void> likeProduct({required LocalProductModel product}) async {
    try {
      emit(state.copyWith(status: LocalStatus.loading));

      await _productProvider.likeProduct(product: product);
      emit(state.copyWith(
        status: LocalStatus.success,
        message: "Product added to favourite.",
      ));
    } catch (error) {
      emit(state.copyWith(
        status: LocalStatus.success,
        message: error.toString(),
      ));
    }
  }

  Future<void> getLikedProducts() async {
    try {
      emit(state.copyWith(status: LocalStatus.loading));
      final likedProducts = await _productProvider.getLikedProducts();
      emit(state.copyWith(
        status: LocalStatus.success,
        likedProducts: likedProducts,
        message: "Product saved successfully",
      ));
    } catch (error) {
      emit(state.copyWith(
        status: LocalStatus.success,
        message: error.toString(),
      ));
    }
  }

  Future<void> getCartProducts() async {
    try {
      emit(state.copyWith(status: LocalStatus.loading));
      final cartItems = await _cartProvider.getCartProducts();
      emit(state.copyWith(
        status: LocalStatus.success,
        cartItems: cartItems,
        message: "Cart items fetched successfully",
      ));
    } catch (error) {
      emit(state.copyWith(
        status: LocalStatus.success,
        message: error.toString(),
      ));
    }
  }

  Future<void> getLaterCartProducts() async {
    try {
      emit(state.copyWith(status: LocalStatus.loading));
      final latercCartItems = await _cartProvider.getLaterCartProducts();
      emit(state.copyWith(
        status: LocalStatus.success,
        laterCartItems: latercCartItems,
        message: "Cart items fetched successfully",
      ));
    } catch (error) {
      emit(state.copyWith(
        status: LocalStatus.success,
        message: error.toString(),
      ));
    }
  }

  Future<void> unLikeProduct({required String id}) async {
    try {
      emit(state.copyWith(status: LocalStatus.loading));
      await _productProvider.unwatchProduct(id: id);
      await _productProvider.unlikeProduct(id: id);
      await getLikedProducts();
      emit(state.copyWith(
        status: LocalStatus.success,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: LocalStatus.success,
        message: error.toString(),
      ));
    }
  }

  Future<void> unSaveProduct({required String id}) async {
    try {
      emit(state.copyWith(status: LocalStatus.loading));
      await _productProvider.unwatchProduct(id: id);
      await _productProvider.unsaveProduct(id: id);
      await getSavedProduct();
      emit(state.copyWith(
        status: LocalStatus.success,
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

  Future<void> addProductToWishlist(
      {required LocalProductModel product}) async {
    try {
      emit(state.copyWith(status: LocalStatus.loading));
      await _productProvider.addProductToWishlist(product: product);
      emit(state.copyWith(
        status: LocalStatus.success,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: LocalStatus.success,
        message: error.toString(),
      ));
    }
  }

  Future<void> addProductToCart({required LocalProductModel product}) async {
    try {
      emit(state.copyWith(status: LocalStatus.loading));
      await _cartProvider.addToCart(product: product);
      emit(state.copyWith(
        status: LocalStatus.success,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: LocalStatus.success,
        message: error.toString(),
      ));
    }
  }

    Future<void> addProductToCartLater({required LocalProductModel product}) async {
    try {
      emit(state.copyWith(status: LocalStatus.loading));
      await _cartProvider.addToCartLater(product: product);
      emit(state.copyWith(
        status: LocalStatus.success,

      ));
    } catch (error) {
      emit(state.copyWith(
        status: LocalStatus.success,
        message: error.toString(),
      ));
    }
  }

  Future<void> removeProductFromWishlist({required String id}) async {
    try {
      emit(state.copyWith(status: LocalStatus.loading));
      await _productProvider.unwatchProduct(id: id);
      await _productProvider.removeFromWishlist(id: id);
      emit(state.copyWith(
        status: LocalStatus.success,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: LocalStatus.success,
        message: error.toString(),
      ));
    }
  }

  Future<void> removeProductFromCart({required String id}) async {
    try {
      emit(state.copyWith(status: LocalStatus.loading));
      await _cartProvider.removeFromCart(id: id);
      emit(state.copyWith(
        status: LocalStatus.success,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: LocalStatus.success,
        message: error.toString(),
      ));
    }
  }

   Future<void> removeProductFromCartLater({required String id}) async {
    try {
      emit(state.copyWith(status: LocalStatus.loading));
      await _cartProvider.removeFromCartLater(id: id);
      emit(state.copyWith(
        status: LocalStatus.removed,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: LocalStatus.success,
        message: error.toString(),
      ));
    }
  }

  Future<void> clearCart() async {
    try {
      emit(state.copyWith(status: LocalStatus.loading));
      await _cartProvider.clearCart();
      emit(state.copyWith(
        status: LocalStatus.success,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: LocalStatus.success,
        message: error.toString(),
      ));
    }
  }
}

enum LocalStatus { initial, loading,removed, success }

class LocalState {
  final LocalStatus status;
  final List<LocalProductModel> savedProducts;
  final List<LocalProductModel> watchedProducts;
  final List<LocalProductModel> wishlistProducts;
  final List<LocalProductModel> likedProducts;
  final List<LocalProductModel> cartItems;
  final List<LocalProductModel> laterCartItems;
  final String message;

  LocalState({
    this.status = LocalStatus.initial,
    this.savedProducts = const [],
    this.watchedProducts = const [],
    this.wishlistProducts = const [],
    this.likedProducts = const [],
    this.cartItems = const [],
    this.laterCartItems = const [],
    this.message = '',
  });

  LocalState copyWith({
    LocalStatus? status,
    List<LocalProductModel>? savedProducts,
    List<LocalProductModel>? watchedProducts,
    List<LocalProductModel>? wishlistProducts,
    List<LocalProductModel>? likedProducts,
    List<LocalProductModel>? cartItems,
    List<LocalProductModel>? laterCartItems,
    String? message,
  }) {
    return LocalState(
      status: status ?? this.status,
      savedProducts: savedProducts ?? this.savedProducts,
      watchedProducts: watchedProducts ?? this.watchedProducts,
      wishlistProducts: wishlistProducts ?? this.wishlistProducts,
      likedProducts: likedProducts ?? this.likedProducts,
      cartItems: cartItems ?? this.cartItems,
      laterCartItems: laterCartItems ?? this.laterCartItems,
      message: message ?? this.message,
    );
  }
}
