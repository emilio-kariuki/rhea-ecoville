import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ecoville/main.dart';
import 'package:ecoville/models/order_model.dart';
import 'package:ecoville/models/order_request_model.dart';
import 'package:ecoville/utilities/packages.dart';

abstract class OrderTemplate {
  Future<List<OrderModel>> getUserOrders();
  Future<bool> cancelOrder({required OrderModel order});
  Future<bool> confirmOrder({required OrderModel order});
  Future<bool> createOrder({required OrderRequestModel order});
}

class OrderRepository implements OrderTemplate {
  @override
  Future<List<OrderModel>> getUserOrders() async {
    try {
      final response = await Dio().get(
          "$API_URL/admin/userOrders",
          options: Options(headers: {
            "APIKEY": API_KEY,
            "user": supabase.auth.currentUser!.id
          }));
      debugPrint(response.toString());
      if (response.statusCode != 200) {
        throw Exception("Error getting the products, ${response.data}");
      }
      final List<OrderModel> products =
          (response.data as List).map((e) => OrderModel.fromJson(e)).toList();
      debugPrint(products.toString());
      return products;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<bool> cancelOrder({required OrderModel order}) async {
    try {
      final response = await Dio()
          .put("$API_URL/admin/updateOrderStatus/${order.id}",
              options: Options(headers: {
                "APIKEY": API_KEY,
                "user": supabase.auth.currentUser!.id,
                "token": order.user.token,
                "email": order.user.email
              }),
              data: {"status": "cancelled"});
      if (response.statusCode != 200) {
        throw Exception("Error getting the products, ${response.data}");
      }
      return true;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<bool> confirmOrder({required OrderModel order}) async {
    try {
      final response = await Dio()
          .put("$API_URL/admin/updateOrderStatus/${order.id}",
              options: Options(headers: {
                "APIKEY": API_KEY,
                "user": supabase.auth.currentUser!.id,
                "token": order.user.token,
                "email": order.user.email
              }),
              data: {"status": "confirmed"});
      if (response.statusCode != 200) {
        throw Exception("Error getting the products, ${response.data}");
      }
      return true;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<bool> createOrder({required OrderRequestModel order}) async {
    try {
      final request = jsonEncode(
        order.toJson(),
      );
      logger.d(request);
      final response = await Dio().post(
        "$API_URL/admin/order",
        options: Options(headers: {
          "APIKEY": API_KEY,
          "user": supabase.auth.currentUser!.id,
        }),
        data: request,
      );
      logger.d(response);
      if (response.statusCode != 200) {
        throw Exception("Error getting the products, ${response.data}");
      }
      return true;
    } catch (e) {
      logger.e(e);
      throw Exception(e);
    }
  }
}
