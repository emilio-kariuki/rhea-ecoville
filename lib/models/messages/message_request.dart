// To parse this JSON data, do
//
//     final messageRequestModel = messageRequestModelFromJson(jsonString);

import 'dart:convert';

MessageRequestModel messageRequestModelFromJson(String str) => MessageRequestModel.fromJson(json.decode(str));

String messageRequestModelToJson(MessageRequestModel data) => json.encode(data.toJson());

class MessageRequestModel {
    final String id;
    final String userId;
    final String sellerId;
    final String message;

    MessageRequestModel({
        required this.id,
        required this.userId,
        required this.sellerId,
        required this.message,
    });

    MessageRequestModel copyWith({
        String? id,
        String? userId,
        String? sellerId,
        String? message,
    }) => 
        MessageRequestModel(
            id: id ?? this.id,
            userId: userId ?? this.userId,
            sellerId: sellerId ?? this.sellerId,
            message: message ?? this.message,
        );

    factory MessageRequestModel.fromJson(Map<String, dynamic> json) => MessageRequestModel(
        id: json["id"],
        userId: json["userId"],
        sellerId: json["sellerId"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "sellerId": sellerId,
        "message": message,
    };
}
