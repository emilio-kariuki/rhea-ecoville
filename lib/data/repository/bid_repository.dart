import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ecoville/data/provider/product_provider.dart';
import 'package:ecoville/data/service/service_locator.dart';
import 'package:ecoville/main.dart';
import 'package:ecoville/models/bid_model.dart';
import 'package:ecoville/utilities/packages.dart';

/// Abstract class `BidTemplate` defining the contract for bid-related operations.
abstract class BidTemplate {
  Future<bool> createBid({required String productId, required int price});
  Future<bool> updateBid({required String bidId, required int price});
  Future<bool> deleteBid({required String id});
  Future<List<BidsModel>> getProductBids({required String productId});
  Future<List<BidsModel>> getUserBids();
}

/// `BidRepository` class implementing `BidTemplate` to manage bids using HTTP requests.
class BidRepository extends BidTemplate {
  final _productProvider = service<ProductProvider>();
  /// Method to create a new bid.
  @override
  Future<bool> createBid({required String productId, required int price}) async {
      try {

      // Creating a JSON-encoded request payload.
      final request = jsonEncode({
        "productId": productId,
        "price": price,
      });
      // Sending a POST request to create a new bid.
      final response = await Dio().post(
          "$API_URL/bid/create",
          data: request,
          options: Options(headers: {
            "APIKEY": API_KEY,
            "user": supabase.auth.currentUser!.id,
            "email": supabase.auth.currentUser!.email,
          }));
        logger.d(response.data);
        // Checking if the response status is not 200 (OK).
      if (response.statusCode != 200) {
        throw Exception("Error getting the products, ${response.data}");
      }
      return true;
    } catch (error) {
       // Handling errors and logging them.
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


  /// Method to update an existing bid.
  @override
  Future<bool> updateBid({required String bidId, required int price}) async {
    try {
      final request = jsonEncode({
        "price": price,
      });
      // Sending a PUT request to update the bid.
      final response = await Dio().put(
          "$API_URL/bid/update/$bidId",
          data: request,
          options: Options(headers: {
            "APIKEY": API_KEY,
            "user": supabase.auth.currentUser!.id // Adding user ID to headers.
          }));
      // Checking if the response status is not 200 (OK).
      if (response.statusCode != 200) {
        throw Exception("Error getting the products, ${response.data}");
      }
      return true; // Returning true if the bid is updated successfully.
    } catch (error) {
      // Handling errors and logging them.
      debugPrint(error.toString());
      throw Exception(error); // Throwing an exception with the error message.
    }
  }

  /// Method to delete a bid by its ID.
  @override
  Future<bool> deleteBid({required String id}) async {
    try {
      // Sending a DELETE request to remove the bid.
      final response = await Dio().delete(
          "$API_URL/bid/delete/$id",
          options: Options(headers: {
            "APIKEY": API_KEY,
            "user": supabase.auth.currentUser!.id
          }));
      // Checking if the response status is not 200 (OK).
      if (response.statusCode != 200) {
        throw Exception("Error getting the products, ${response.data}");
      }
      return true; // Returning true if the bid is deleted successfully.
    } catch (error) {
      // Handling errors and logging them.
      debugPrint(error.toString());
      throw Exception("Error updating the bid, $error");
    }
  }

  /// Method to retrieve all bids for a specific product.
  @override
  Future<List<BidsModel>> getProductBids({required String productId}) async {
     try {
      // Sending a GET request to retrieve product bids.
      final response = await Dio().get(
          "$API_URL/bid/product/$productId",
          options: Options(headers: {
            "APIKEY": API_KEY,
          }));
      logger.d(response.data);
      if (response.statusCode != 200) {
        throw Exception("Error getting the products, ${response.data}");
      }
      // Mapping the response data to a list of BidsModel.
      final List<BidsModel> bids =
          (response.data as List).map((e) => BidsModel.fromJson(e)).toList();
      return bids;// Returning the list of bids.
    } catch (error) {
      debugPrint(error.toString());
      throw Exception("Error updating the bid, $error");
    }
  }

  /// Method to retrieve all bids made by the current user.
  @override
  Future<List<BidsModel>> getUserBids() async {
    try {
      // Sending a PUT request to retrieve the user's bids.
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
    } catch (error) {
      debugPrint(error.toString());
      throw Exception("Error updating the bid, $error");
    }
  }
  
  
}
