import 'package:ecoville/data/provider/rating_provider.dart';
import 'package:ecoville/data/service/service_locator.dart';
import 'package:ecoville/models/rating_model.dart';
import 'package:ecoville/utilities/packages.dart';

class RatingCubit extends Cubit<RatingState> {
  final _ratingProvider = service<RatingProvider>();
  RatingCubit() : super(RatingState());

  Future<void> addRating(
      {required String productId,
      required String description,
      required double rating}) async {
    try {
      emit(state.copyWith(status: RatingStatus.loading));
      await _ratingProvider.addRating(
          productId: productId, description: description, rating: rating);
      emit(state.copyWith(
          message: "Rating added successfully", status: RatingStatus.success));
    } catch (e) {
      emit(state.copyWith(status: RatingStatus.error, message: e.toString()));
    }
  }

  Future<void> getProductRatings({required String productId}) async {
    try {
      emit(state.copyWith(status: RatingStatus.loading));
      await _ratingProvider.getProductRatings(
          productId: productId,);
      emit(state.copyWith(
          message: "Product ratings fetched successfully", status: RatingStatus.success));
    } catch (e) {
      emit(state.copyWith(status: RatingStatus.error, message: e.toString()));
    }
  }

  Future<void> getSellerRatings({required String userId}) async {
    try {
      emit(state.copyWith(status: RatingStatus.loading));
      await _ratingProvider.getSellerRatings(
          userId: userId,);
      emit(state.copyWith(
          message: "Product ratings fetched successfully", status: RatingStatus.success));
    } catch (e) {
      emit(state.copyWith(status: RatingStatus.error, message: e.toString()));
    }
  }
}

enum RatingStatus { initial, loading, success, error }

class RatingState {
  final String message;
  final RatingStatus status;
  final List<RatingModel> userRatings;
  final List<RatingModel> productRatings;

  RatingState(
      {this.message = '',
      this.productRatings = const [],
      this.userRatings = const [],
      this.status = RatingStatus.initial});

  RatingState copyWith(
      {final String? message,
      final RatingStatus? status,
      final List<RatingModel>? userRatings,
      final List<RatingModel>? productRatings}) {
    return RatingState(
        message: message ?? this.message,
        status: status ?? this.status,
        userRatings: userRatings ?? this.userRatings,
        productRatings: productRatings ?? this.productRatings);
  }
}
