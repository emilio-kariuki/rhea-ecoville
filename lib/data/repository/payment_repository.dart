import 'dart:convert';

import 'package:ecoville/data/local/local_database.dart';
import 'package:ecoville/data/service/service_locator.dart';
import 'package:ecoville/models/confirm_payment_model.dart';
import 'package:ecoville/models/initiated_payment_model.dart';
import 'package:dio/dio.dart';
import 'package:ecoville/utilities/app_contants.dart';
import 'package:ecoville/utilities/packages.dart';

abstract class PaymentTemplate {
  Future<InitiatedPaymentModel> initiatePayment({
    required int phone,
    required double amount,
    required List<String> products,
  });
  Future<ConfirmPaymentModel> confirmPayment({
    required String checkoutRequestID,
    required List<String> products,
  });

  Future<void> completePayment({
    required String checkoutRequestID,
    required List<String> products,
  });
}

class PaymentRepository implements PaymentTemplate {
  @override
  Future<InitiatedPaymentModel> initiatePayment({
    required int phone,
    required double amount,
    required List<String> products,
  }) async {
    final request = {
      'phone': '254$phone',
      'amount': 1,
    };
    final req = jsonEncode(request);
    try {
      final response = await Dio().post(
        'https://ecoville.site/api/mpesa',
        data: req,
      );
      if (response.statusCode == 200) {
        return InitiatedPaymentModel.fromJson(response.data);
      } else {
        throw Exception('Failed to initiate payment');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<ConfirmPaymentModel> confirmPayment({
    required String checkoutRequestID,
    required List<String> products,
  }) async {
    final request = {
      'checkoutRequestID': checkoutRequestID,
    };
    final req = jsonEncode(request);
    try {
      final response = await Dio().post(
        'https://ecoville.site/api/mpesa/confirm',
        data: req,
      );
      if (response.statusCode == 200) {
        return ConfirmPaymentModel.fromJson(response.data);
      } else {
        throw Exception('Failed to confirm payment');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> completePayment(
      {required String checkoutRequestID,
      required List<String> products}) async {
    try {
      final _dbHelper = service<DatabaseHelper>();
      final db = await _dbHelper.init();
      final response = await Dio().post(
        'https://fuvjfsjfehyistbfkmkg.supabase.co/functions/v1/product-purchase',
        options: Options(headers: {
          "Authorization":
              "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1dmpmc2pmZWh5aXN0YmZrbWtnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTU5NDU0ODMsImV4cCI6MjAzMTUyMTQ4M30.EaKs4B9BheWafF7u2Cz0uQhw-m9C8LTVYuT_YVlXGR4"
        }),
        data: {
          'checkoutRequestID': checkoutRequestID,
          'products': products,
        },
      );
      if (response.statusCode == 200) {
        await db.delete(LOCAL_TABLE_CART);
        return;
      } else {
        throw Exception('Failed to complete payment');
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
