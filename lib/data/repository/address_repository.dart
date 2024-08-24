import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ecoville/main.dart';
import 'package:ecoville/models/address_model.dart';
import 'package:ecoville/utilities/packages.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

abstract class AddressTemplate {
  Future<bool> addAddress({required AddressRequestModel address});
  Future<bool> removeAddress({required String id});
  Future<List<AddressModel>> getAddresses();
  Future<AddressModel?> getAddressById({required String id});
  Future<bool> updateAddress(
      {required AddressRequestModel address, required String id});
}

class AddressRepository extends AddressTemplate {
  @override
  Future<bool> addAddress({required AddressRequestModel address}) async {
    try {
      logger.d("Address: ${address.toJson()}");
      final request = jsonEncode(address.toJson());
      final response = await Dio().post("$API_URL/address/create",
          data: request,
          options: Options(headers: {
            "APIKEY": API_KEY,
            "user": supabase.auth.currentUser!.id
          }));
      logger.d("Response: ${response.data}");
      if (response.statusCode != 200) {
        throw Exception("Error creating the address, ${response.data}");
      }
      
      return true;
    } catch (error, stackTrace) {
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );
      debugPrint(error.toString());
      throw Exception("Error getting the products, $error");
    }
  }
  

  @override
  Future<List<AddressModel>> getAddresses() async {
    try {
      final response = await Dio().get("$API_URL/address/get",
          options: Options(headers: {
            "APIKEY": API_KEY,
            "user": supabase.auth.currentUser!.id
          }));
      if (response.statusCode != 200) {
        throw Exception("Error creating the address, ${response.data}");
      }
      final List<AddressModel> addresses =
          (response.data as List).map((e) => AddressModel.fromJson(e)).toList();
      return addresses;
    } catch (error, stackTrace) {
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );
      debugPrint(error.toString());
      return [];
    }
  }

  @override
  Future<bool> removeAddress({required String id}) async {
    try {
      final response = await Dio().delete("$API_URL/address/delete/$id",
          options: Options(headers: {
            "APIKEY": API_KEY,
            "user": supabase.auth.currentUser!.id
          }));
      logger.d("Response: ${response.data}");
      if (response.statusCode != 200) {
        throw Exception("Error deleting the address, ${response.data}");
      }

      return true;
    } catch (error, stackTrace) {
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );
      debugPrint(error.toString());
      return false;
    }
  }

  @override
  Future<bool> updateAddress(
      {required AddressRequestModel address, required String id}) async {
    try {
      final request = jsonEncode(address.toJson());
      final response = await Dio().put("$API_URL/address/update/$id",
          data: request,
          options: Options(headers: {
            "APIKEY": API_KEY,
            "user": supabase.auth.currentUser!.id
          }));
      if (response.statusCode != 200) {
        throw Exception("Error updating the address, ${response.data}");
      }
      return true;
    } catch (error, stackTrace) {
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );
      debugPrint(error.toString());
      return false;
    }
  }

  @override
  Future<AddressModel?> getAddressById({required String id}) async {
    try {
      final response = await Dio().get("$API_URL/address/get/$id",
          options: Options(headers: {
            "APIKEY": API_KEY,
            "user": supabase.auth.currentUser!.id
          }));
      if (response.statusCode != 200) {
        throw Exception("Error getting the address, ${response.data}");
      }
      final AddressModel address = AddressModel.fromJson(response.data);
      return address;
    } catch (error, stackTrace) {
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );
      debugPrint(error.toString());
      return null;
    }
  }
}
