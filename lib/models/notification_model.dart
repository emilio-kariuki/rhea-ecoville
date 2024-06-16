// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

List<NotificationModel> notificationModelFromJson(String str) => List<NotificationModel>.from(json.decode(str).map((x) => NotificationModel.fromJson(x)));

String notificationModelToJson(List<NotificationModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NotificationModel {
    final String id;
    final String userId;
    final String title;
    final String description;
    final DateTime createdAt;
    final DateTime updatedAt;
    final bool isRead;

    NotificationModel({
        required this.id,
        required this.userId,
        required this.title,
        required this.description,
        required this.createdAt,
        required this.updatedAt,
        required this.isRead,
    });

    NotificationModel copyWith({
        String? id,
        String? userId,
        String? title,
        String? description,
        DateTime? createdAt,
        DateTime? updatedAt,
        bool? isRead,
    }) => 
        NotificationModel(
            id: id ?? this.id,
            userId: userId ?? this.userId,
            title: title ?? this.title,
            description: description ?? this.description,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            isRead: isRead ?? this.isRead,
        );

    factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
        id: json["id"],
        userId: json["userId"],
        title: json["title"],
        description: json["description"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        isRead: json["isRead"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "title": title,
        "description": description,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "isRead": isRead,
    };
}
