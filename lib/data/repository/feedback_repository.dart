import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ecoville/utilities/packages.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

abstract class FeedbackTemplate {
  Future<bool> addFeedback({required String message});
}

class FeedbackRepository extends FeedbackTemplate {
  @override
  Future<bool> addFeedback({required String message}) async {
    try {
      final request = jsonEncode({
        "message": message,
      });
      final response = await Dio().post("$API_URL/feedback/add",
          data: request,
          options: Options(headers: {
            "APIKEY": API_KEY,
            "user": supabase.auth.currentUser!.id,
            "email": supabase.auth.currentUser!.email,
            "token": await FirebaseMessaging.instance.getToken(),
          }));
      debugPrint(response.data.toString());
      if (response.statusCode != 200) {
        throw Exception("Error adding the feedback, ${response.data}");
      }
      return true;
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      throw Exception(e);
    }
  }
}
