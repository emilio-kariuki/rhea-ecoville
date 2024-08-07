import 'package:ecoville/models/interactions_model.dart';
import 'package:ecoville/models/product_model.dart';
import '../../models/local_product_model.dart';

class ProductCube{

}
enum ProductStatus{initial, loading, success, error, created, updated }
class ProductState{
  final ProductModel? product;
  final List<ProductModel>? products;
  final List<InteractionsModel>? savedProducts;
  final List<ProductModel>? sellerProducts;
  final List<ProductModel>? biddingProducts;
  final List<LocalProductModel>? watchedProducts;
  final ProductStatus status;
  final String message;

  ProductState({
    this.product,
    this.products = const <ProductModel>[],
    this.savedProducts = const <InteractionsModel>[],
    this.sellerProducts = const <ProductModel>[],
    this.biddingProducts = const <ProductModel>[],
    this.watchedProducts = const <LocalProductModel>[],
    this.status = ProductStatus.initial ,
    this.message = '',
  });
  ProductState copyWith({
    ProductModel? product,
    List<ProductModel>? products,
    List<ProductModel>? sellerProducts,
    List<ProductModel>? biddingProducts,
    List<InteractionsModel>? savedProducts,
    List<LocalProductModel>? watchedProducts,
    ProductStatus? status,
    String? message,
  }) { return ProductState(
    product: product ?? this.product,
    products: products ?? this.products,
    sellerProducts: sellerProducts ?? this.sellerProducts,
    biddingProducts: biddingProducts ?? this.biddingProducts,
    savedProducts: savedProducts ?? this.savedProducts,
    watchedProducts: watchedProducts ?? this.watchedProducts,
    status: status ?? this.status,
    message: message ?? this.message
  );}
}