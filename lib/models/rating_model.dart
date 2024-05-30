// To parse this JSON data, do
//
//     final ratingModel = ratingModelFromJson(jsonString);

import 'dart:convert';

import 'package:ecoville/models/user_model.dart';


List<RatingModel> ratingModelFromJson(String str) => List<RatingModel>.from(
    json.decode(str).map((x) => RatingModel.fromJson(x)));

String ratingModelToJson(List<RatingModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RatingModel {
  final String id;
  final String userId;
  final String sellerId;
  final String productId;
  final String description;
  final double rating;
  final DateTime createdAt;
  final UserModel user;
  // final ProductModel product;

  RatingModel({
    required this.id,
    required this.userId,
    required this.sellerId,
    required this.productId,
    required this.rating,
    required this.description,
    required this.createdAt,
    required this.user,
    // required this.product,
  });

  RatingModel copyWith({
    String? id,
    String? userId,
    String? sellerId,
    String? productId,
    double? rating,
    String? description,
    DateTime? createdAt,
    UserModel? user,
    // ProductModel? product,
  }) =>
      RatingModel(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        sellerId: sellerId ?? this.sellerId,
        productId: productId ?? this.productId,
        rating: rating ?? this.rating,
        description: description ?? this.description,
        createdAt: createdAt ?? this.createdAt,
        user: user ?? this.user,
        // product: product ?? this.product,
      );

  factory RatingModel.fromJson(Map<String, dynamic> json) => RatingModel(
        id: json["id"],
        userId: json["userId"],
        sellerId: json["sellerId"],
        productId: json["productId"],
        rating: json["rating"],
        description: json["description"],
        createdAt: DateTime.parse(json["createdAt"]),
        user: UserModel.fromJson(json["user"]),
        // product: ProductModel.fromJson(json["product"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "sellerId": sellerId,
        "productId": productId,
        "rating": rating,
        "description": description,
        "createdAt": createdAt.toIso8601String(),
        // "product": product.toJson(),
      };
}
