import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ecoville/main.dart';
import 'package:ecoville/models/rating_model.dart';
import 'package:ecoville/utilities/packages.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

abstract class RatingTemplate {
  Future<bool> addRating(
      {required String productId,
      required String review,
      required String sellerId,
      required String orderId,
      required double rating});
  Future<List<RatingModel>> getSellerRatings({required String userId});
  Future<List<RatingModel>> getProductRatings({
    required String productId,
  });
}

class RatingRepository extends RatingTemplate {
  @override
  Future<bool> addRating(
      {required String productId,
      required String review,
      required String sellerId,
      required String orderId,
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
      await Dio().put("$API_URL/admin/order/$orderId",
          options: Options(headers: {
            "APIKEY": API_KEY,
            "user": supabase.auth.currentUser!.id,
          }),
          data: {"reviewed": true});
      if (response.statusCode != 200) {
        throw Exception("Error adding rating, ${response.data}");
      }
      return true;
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      debugPrint(e.toString());
      throw Exception(
        "Error adding rating: $e",
      );
    }
  }

  @override
  Future<List<RatingModel>> getProductRatings({
    required String productId,
  }) async {
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
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      debugPrint(e.toString());
      throw Exception(
        "Error get product ratings: $e",
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
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      debugPrint(e.toString());
      throw Exception(
        "Error getting user ratings: $e",
      );
    }
  }
}
