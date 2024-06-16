// To parse this JSON data, do
//
//     final conversationModel = conversationModelFromJson(jsonString);

import 'dart:convert';

import 'package:ecoville/models/user_model.dart';

List<ConversationModel> conversationModelFromJson(String str) =>
    List<ConversationModel>.from(
        json.decode(str).map((x) => ConversationModel.fromJson(x)));

String conversationModelToJson(List<ConversationModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ConversationModel {
  final String id;
  final String userId;
  final String sellerId;
  final String message;
  final UserModel? user;
  final DateTime createdAt;
  final DateTime updatedAt;

  ConversationModel({
    required this.id,
    required this.userId,
    required this.sellerId,
    required this.message,
    required this.user,
    required this.createdAt,
    required this.updatedAt,
  });

  ConversationModel copyWith({
    String? id,
    String? userId,
    String? sellerId,
    String? message,
    UserModel? user,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      ConversationModel(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        sellerId: sellerId ?? this.sellerId,
        message: message ?? this.message,
        user: user ?? this.user,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory ConversationModel.fromJson(Map<String, dynamic> json) =>
      ConversationModel(
        id: json["id"],
        userId: json["userId"],
        sellerId: json["sellerId"],
        message: json["message"],
        user: json["ecoville_user"] == null
            ? null
            : UserModel.fromJson(json["ecoville_user"]),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "sellerId": sellerId,
        "message": message,
        "ecoville_user": user!.toJson(),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
