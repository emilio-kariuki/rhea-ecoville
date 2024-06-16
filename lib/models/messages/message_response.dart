// To parse this JSON data, do
//
//     final messageResponseModel = messageResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:ecoville/models/user_model.dart';

List<MessageResponseModel> messageResponseModelFromJson(String str) => List<MessageResponseModel>.from(json.decode(str).map((x) => MessageResponseModel.fromJson(x)));

String messageResponseModelToJson(List<MessageResponseModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MessageResponseModel {
    final String id;
    final String userId;
    final String sellerId;
    final String message;
    final String conversationId;
    final UserModel? user;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    MessageResponseModel({
        required this.id,
        required this.userId,
        required this.sellerId,
        required this.message,
         this.user,
        required this.conversationId,
         this.createdAt,
         this.updatedAt,
    });

    MessageResponseModel copyWith({
        String? id,
        String? userId,
        String? sellerId,
        String? message,
        UserModel? user,
        String? conversationId,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        MessageResponseModel(
            id: id ?? this.id,
            userId: userId ?? this.userId,
            sellerId: sellerId ?? this.sellerId,
            message: message ?? this.message,
            user: user ?? this.user,
            conversationId: conversationId ?? this.conversationId,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory MessageResponseModel.fromJson(Map<String, dynamic> json) => MessageResponseModel(
        id: json["id"],
        userId: json["userId"],
        sellerId: json["sellerId"],
        message: json["message"],
        user: json["ecoville_user"] == null ? null : UserModel.fromJson(json["ecoville_user"]),
        conversationId: json["conversationsId"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "sellerId": sellerId,
        "message": message,
        "ecoville_user": user!.toJson(),
        "conversationsId": conversationId,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
    };
}
