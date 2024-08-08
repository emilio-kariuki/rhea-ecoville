import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ecoville/main.dart';
import 'package:ecoville/models/rating_model.dart';
import 'package:ecoville/utilities/packages.dart';

abstract class RatingTemplate {
  Future<bool> addRating(
      {required String productId,
      required String review,
      required String sellerId,
      required double rating});
  Future<List<RatingModel>> getSellerRatings({required String userId});
  Future<List<RatingModel>> getProductRatings(
      {required String productId,});

}

class RatingRepository extends RatingTemplate {
  @override
  Future<bool> addRating(
      {required String productId,
      required String review,
      required String sellerId,
      required double rating}) async {
    try {
      final request = jsonEncode({
        "productId": productId,
        "review": review,
        "sellerId": sellerId,
        "rating": rating,
      });
      final response = await Dio().post("$API_URL/rating/add",
          data: request,
          options: Options(headers: {
            "APIKEY": API_KEY,
            "user": supabase.auth.currentUser!.id
          }));
      if (response.statusCode != 200) {
        throw Exception("Error adding rating, ${response.data}");
      }
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
      final response = await Dio().get("$API_URL/rating/product/$productId",
          options: Options(headers: {
            "APIKEY": API_KEY,
            "user": supabase.auth.currentUser!.id
          }));
      if (response.statusCode != 200) {
        throw Exception("Error getting product rating, ${response.data}");
      }
      logger.d(response.data);
      final List<RatingModel> rating =
          (response.data as List).map((e) => RatingModel.fromJson(e)).toList();
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
      final response = await Dio().get("$API_URL/rating/seller/$userId",
          options: Options(headers: {
            "APIKEY": API_KEY,
            "user": supabase.auth.currentUser!.id
          }));
      if (response.statusCode != 200) {
        throw Exception("Error getting product rating, ${response.data}");
      }
      logger.d(response.data);
     final List<RatingModel> rating =
          (response.data as List).map((e) => RatingModel.fromJson(e)).toList();
      return rating;
    } catch (error) {
      debugPrint(error.toString());
      throw Exception(
        "Error getting user ratings: $error",
      );
    }
  }
}
