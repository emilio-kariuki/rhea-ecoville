import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ecoville/main.dart';
import 'package:ecoville/models/order_model.dart';
import 'package:ecoville/models/order_request_model.dart';
import 'package:ecoville/utilities/packages.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

abstract class OrderTemplate {
  Future<List<OrderModel>> getUserOrders();
  Future<bool> cancelOrder({required OrderModel order});
  Future<bool> confirmOrder({required OrderModel order});
  Future<bool> returnOrder({required OrderModel order});
  Future<bool> createOrder({required OrderRequestModel order});
  Future<List<OrderModel>> getAllOrders();
  Future<bool> payOrder({required String orderId, required String phone, required int amount});
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
      // sort the orders by date
      products.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      debugPrint(products.toString());
      return products;
    }   catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
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
    }   catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
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
              data: {"status": "completed"});
      if (response.statusCode != 200) {
        throw Exception("Error getting the products, ${response.data}");
      }
      return true;
    }   catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      throw Exception(e);
    }
  }


  @override
  Future<bool> returnOrder({required OrderModel order}) async {
    try {
      final response = await Dio()
          .put("$API_URL/admin/updateOrderStatus/${order.id}",
              options: Options(headers: {
                "APIKEY": API_KEY,
                "user": supabase.auth.currentUser!.id,
                "token": order.user.token,
                "email": order.user.email
              }),
              data: {"status": "returned"});
      if (response.statusCode != 200) {
        throw Exception("Error getting the products, ${response.data}");
      }
      return true;
    }   catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
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
    }   catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      logger.e(e);
      throw Exception(e);
    }
  }
  
  @override
  Future<List<OrderModel>> getAllOrders() async{
   try {
      final response = await Dio().get(
          "$API_URL/admin/orders",
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
    }   catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      throw Exception(e);
    }
  }
  
  @override
  Future<bool> payOrder({required String orderId, required String phone, required int amount}) async{
    try {
      final request = {
        'orderId': orderId,
        'userId': supabase.auth.currentUser!.id,
        'amount': amount,
        'phone': phone,
      };
      final response = await Dio().post(
          "$API_URL/mpesa/initiatestkpush",
          data: jsonEncode(request),
          options: Options(headers: {
            "APIKEY": API_KEY,
            "user": supabase.auth.currentUser!.id
          }));
      if (response.statusCode != 200) {
        throw Exception("Error getting the products, ${response.data}");
      }
      return true;
    }   catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }
}
