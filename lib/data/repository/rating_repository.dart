import 'package:ecoville/models/rating_model.dart';
import 'package:ecoville/utilities/packages.dart';

abstract class RatingTemplate {
  Future<bool> addRating(
      {required String productId,
      required String description,
      required double rating});
  Future<List<RatingModel>> getSellerRatings({required String userId});
  Future<List<RatingModel>> getProductRatings(
      {required String productId,});
}

class RatingRepository extends RatingTemplate {
  @override
  Future<bool> addRating(
      {required String productId,
      required String description,
      required double rating}) async {
    try {
      final userId = supabase.auth.currentUser!.id;
      final id = const Uuid().v4();
      await supabase.from(TABLE_RATING).insert({
        id: id,
        "userId": userId,
        "productId": productId,
        "rating": rating,
        "description": description
      });
      return true;
    } catch (error) {
      debugPrint(error.toString());
      throw Exception(
        "Error adding rating: $error",
      );
    }
  }

  @override
  Future<List<RatingModel>> getProductRatings(
      {required String productId,}) async {
    try {
      final response = await supabase
          .from(TABLE_RATING)
          .select("user:ecoville_user(*), product:ecoville_product(*), *")
          .eq("productId", productId);
      final rating = response.map((e) => RatingModel.fromJson(e)).toList();
      return rating;
    } catch (error) {
      debugPrint(error.toString());
      throw Exception(
        "Error get product ratings: $error",
      );
    }
  }

  @override
  Future<List<RatingModel>> getSellerRatings({required String userId}) async {
    try {

      final response = await supabase
          .from(TABLE_RATING)
          .select("user:ecoville_user(*), product:ecoville_product(*), *")
          .eq("userId", userId);
      final rating = response.map((e) => RatingModel.fromJson(e)).toList();
      return rating;
    } catch (error) {
      debugPrint(error.toString());
      throw Exception(
        "Error getting user ratings: $error",
      );
    }
  }
}
