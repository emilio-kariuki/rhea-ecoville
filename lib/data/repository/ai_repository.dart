import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ecoville/main.dart';
import 'package:ecoville/models/title_description_model.dart';
import 'package:ecoville/utilities/packages.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

abstract class AiTemplate {
  Future<TitleDescriptionModel> generateTitleAndDescription(
      {required String query});
}

class AiRepository extends AiTemplate {
  @override
  Future<TitleDescriptionModel> generateTitleAndDescription(
      {required String query}) async {
    try {
      final request = jsonEncode({"query": query});
      final response = await Dio().get(
          "$API_URL/ai/generate/title_and_description",
          data: request,
          options: Options(headers: {
            "APIKEY": API_KEY,
            "user": supabase.auth.currentUser!.id
          }));
      debugPrint(response.data.toString());
      if (response.statusCode != 200) {
        throw Exception("Error getting the products, ${response.data}");
      }
      final generation = TitleDescriptionModel.fromJson(response.data);
      return generation;
    } catch (error, stackTrace) {
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );
      logger.e(error);
      throw Exception(error);
    }
  }
}
