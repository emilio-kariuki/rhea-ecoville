import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ecoville/main.dart';
import 'package:ecoville/models/bid_model.dart';
import 'package:ecoville/utilities/packages.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

abstract class BidTemplate {
  Future<bool> createBid({required String productId, required int price});
  Future<bool> updateBid({required String bidId, required int price});
  Future<bool> deleteBid({required String id});
  Future<List<BidsModel>> getProductBids({required String productId});
  Future<List<BidsModel>> getUserBids();
}

class BidRepository extends BidTemplate {
  @override
  Future<bool> createBid({required String productId, required int price}) async {
      try {

      final request = jsonEncode({
        "productId": productId,
        "price": price,
      });
      final response = await Dio().post(
          "$API_URL/bid/create",
          data: request,
          options: Options(headers: {
            "APIKEY": API_KEY,
            "user": supabase.auth.currentUser!.id,
            "email": supabase.auth.currentUser!.email,
          }));
        logger.d(response.data);
      if (response.statusCode != 200) {
        throw Exception("Error getting the products, ${response.data}");
      }
      analytics.logEvent(name: "create_bid", parameters: {
        "productId": productId,
        "price": price,
      });
      return true;
    } catch (error, stackTrace) {
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );
      debugPrint(error.toString());
      throw DioException(
          requestOptions: RequestOptions(path: "$API_URL/bid/create"),
          response: Response(
              requestOptions: RequestOptions(path: "$API_URL/bid/create"),
              statusCode: 500,
              data: error.toString())
      );
    }
  }


  @override
  Future<bool> updateBid({required String bidId, required int price}) async {
    try {
      final request = jsonEncode({
        "price": price,
      });
      final response = await Dio().put(
          "$API_URL/bid/update/$bidId",
          data: request,
          options: Options(headers: {
            "APIKEY": API_KEY,
            "user": supabase.auth.currentUser!.id
          }));
      if (response.statusCode != 200) {
        throw Exception("Error getting the products, ${response.data}");
      }
      return true;
    } catch (error, stackTrace) {
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );
      debugPrint(error.toString());
      throw Exception(error);
    }
  }

  @override
  Future<bool> deleteBid({required String id}) async {
    try {
      final response = await Dio().delete(
          "$API_URL/bid/delete/$id",
          options: Options(headers: {
            "APIKEY": API_KEY,
            "user": supabase.auth.currentUser!.id
          }));
      if (response.statusCode != 200) {
        throw Exception("Error getting the products, ${response.data}");
      }
      return true;
    } catch (error, stackTrace) {
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );
      debugPrint(error.toString());
      throw Exception("Error updating the bid, $error");
    }
  }

  @override
  Future<List<BidsModel>> getProductBids({required String productId}) async {
     try {
      final response = await Dio().get(
          "$API_URL/bid/product/$productId",
          options: Options(headers: {
            "APIKEY": API_KEY,
          }));
      logger.d(response.data);
      if (response.statusCode != 200) {
        throw Exception("Error getting the products, ${response.data}");
      }
      final List<BidsModel> bids =
          (response.data as List).map((e) => BidsModel.fromJson(e)).toList();
      return bids;
    } catch (error, stackTrace) {
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );
      debugPrint(error.toString());
      throw Exception("Error updating the bid, $error");
    }
  }

  @override
  Future<List<BidsModel>> getUserBids() async {
    try {
      final response = await Dio().put(
          "$API_URL/bid/userbids",
          options: Options(headers: {
            "APIKEY": API_KEY,
            "user": supabase.auth.currentUser!.id,
          }));
      if (response.statusCode != 200) {
        throw Exception("Error getting the products, ${response.data}");
      }
      final List<BidsModel> bids = response.data.map((e) => BidsModel.fromJson(e)).toList();
      return bids;
    } catch (error, stackTrace) {
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );
      debugPrint(error.toString());
      throw Exception("Error updating the bid, $error");
    }
  }
  
  
}
