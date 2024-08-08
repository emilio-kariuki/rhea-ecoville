import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ecoville/data/repository/notification_repository.dart';
import 'package:ecoville/main.dart';
import 'package:ecoville/models/user_model.dart';
import 'package:ecoville/utilities/packages.dart';

abstract class UserTemplate {
  Future<bool> createUser({required UserModel user});
  Future<UserModel> getUser();
  Future<UserModel> getUserById({required String id});
  Future<UserModel> updateUser({required UserModel user});
  Future<bool> sendUserInteractions(
      {required String userId,
      required String interaction,
      required String productId});
  Future<bool> updateFCMToken();
}

class UserRepository extends UserTemplate {
  @override
  Future<bool> createUser({required UserModel user}) async {
    try {
      final request = jsonEncode({
        "id": user.id,
        "email": user.email,
        "name": user.name,
        "image": user.image,
        "token": user.token,
        "role": user.role,
      });
      final response = await Dio().post(
          "$API_URL/user/create/",
          data: request,
          options: Options(headers: {
            "APIKEY": API_KEY,
            "user": supabase.auth.currentUser!.id
          }));
      if (response.statusCode != 200) {
        throw Exception("Error getting the products, ${response.data}");
      }
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  @override
  Future<UserModel> getUser() async {
    try {
      final id = supabase.auth.currentUser!.id;
      final response = await Dio().get(
          "$API_URL/user/get/$id",
          options: Options(headers: {
            "APIKEY": API_KEY,
            "user": supabase.auth.currentUser!.id
          }));
         
      if (response.statusCode != 200) {
        throw Exception("Error getting the products, ${response.data}");
      }
      final user = UserModel.fromJson(response.data);
      logger.d("user role: ${user.toJson()}");
      return user;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Error getting user');
    }
  }

  @override
  Future<UserModel> updateUser({required UserModel user}) async {
    try {
      final request = jsonEncode(user.toJson());
      final id = supabase.auth.currentUser!.id;
      final response = await Dio().put(
          "$API_URL/user/update/$id",
          data: request,
          options: Options(headers: {
            "APIKEY": API_KEY,
            "user": supabase.auth.currentUser!.id
          }));
      if (response.statusCode != 200) {
        throw Exception("Error getting the products, ${response.data}");
      }
      final updatedUser = UserModel.fromJson(response.data);
      return updatedUser;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Error updating user');
    }
  }

  @override
  Future<bool> sendUserInteractions(
      {required String userId,
      required String interaction,
      required String productId}) {
    throw UnimplementedError();
  }

  @override
  Future<UserModel> getUserById({required String id}) async {
    debugPrint('Getting user by id');
    try {
      final response = await supabase.from(TABLE_USERS).select().eq('id', id);
      final user = UserModel.fromJson(response.first);
      return user;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Error getting user by id');
    }
  }
  
  @override
  Future<bool> updateFCMToken() async{
    try{
      final request = jsonEncode({
        "token": await NotificationRepository().getNotificationToken()
      });
      final id = supabase.auth.currentUser!.id;
      final response = await Dio().put(
          "$API_URL/user/update/$id",
          data: request,
          options: Options(headers: {
            "APIKEY": API_KEY,
            "user": supabase.auth.currentUser!.id
          }));
      if (response.statusCode != 200) {
        throw Exception("Error getting the products, ${response.data}");
      }
      return true;
    }catch(e){
      debugPrint(e.toString());
      return false;
    }
  }
}
