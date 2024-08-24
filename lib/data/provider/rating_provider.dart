import 'package:ecoville/data/repository/rating_repository.dart';
import 'package:ecoville/models/rating_model.dart';

class RatingProvider extends RatingTemplate {
  final RatingRepository _ratingRepository;
  RatingProvider({required RatingRepository ratingRepository})
      : _ratingRepository = ratingRepository;

  @override
  Future<bool> addRating({required String productId, required String review, required String sellerId,required String orderId,required double rating}) {
    return _ratingRepository.addRating(productId: productId, review: review, rating: rating, sellerId: sellerId, orderId: orderId,);
  }

  @override
  Future<List<RatingModel>> getProductRatings({required String productId,}) {
    return _ratingRepository.getProductRatings(productId: productId, );
  }

  @override
  Future<List<RatingModel>> getSellerRatings({required String userId}) {
    return _ratingRepository.getSellerRatings(userId: userId);
  }

}
