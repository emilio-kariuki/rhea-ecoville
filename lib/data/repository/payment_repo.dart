import 'dart:convert';

import 'package:ecoville/data/local/local_database.dart';
import 'package:ecoville/data/service/service_locator.dart';
import 'package:ecoville/models/confirm_payment_model.dart';
import 'package:ecoville/models/initiated_payment_model.dart';
import 'package:dio/dio.dart';
import 'package:ecoville/utilities/app_contants.dart';
import 'package:ecoville/utilities/packages.dart';

abstract class paymentTemp{
  Future<InitiatedPaymentModel> initiatePayment({
    required int phone,
    required double amount,
    required List<String> products
});
  Future<ConfirmPaymentModel> confirmPayment({
    required String checkoutRequestID,
    required List<String> products
});
  Future<void> completePayment({
    required String checkoutRequestID,
    required List<String> products});
}

class PaymentRepo implements paymentTemp{
  @override
  Future<void> completePayment({
    required String checkoutRequestID,
    required List<String> products}) async{
  }

  @override
  Future<ConfirmPaymentModel> confirmPayment({required String checkoutRequestID, required List<String> products}) async {
    final request = {
      'checkoutRequestID' : checkoutRequestID
    };
    final req = jsonEncode(request);
    try {
      final response = await Dio().post(
        'https://ecoville.site/api/mpesa',
        data: req
      );
      debugPrint("Confirming Payment:${response.data} ");
      if(response.statusCode != 200){
        throw Exception('Failed to confirm payment');
      }
      final data = jsonDecode(response.data);
      debugPrint(data.toString());
      return ConfirmPaymentModel.fromJson(data);
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  @override
  Future<InitiatedPaymentModel> initiatePayment({required int phone, required double amount, required List<String> products}) async {
    final request = {
      'phone' : phone,
      'amount' : amount
    };
    debugPrint(request.toString());
    final req = jsonEncode(request);
    try {
      final response = await Dio().post(
        'https://ecoville.site/api/mpesa',
        data: req
      );
      if(response.statusCode != 200){
        throw Exception('Failed to initiate payment');
      }
      final data = jsonDecode(response.data);
      return InitiatedPaymentModel.fromJson(data);
    } catch (e){
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

}