// To parse this JSON data, do
//
//     final ratingModel = ratingModelFromJson(jsonString);

import 'dart:convert';

import 'package:ecoville/models/product_model.dart';
import 'package:ecoville/models/user_model.dart';

List<RatingModel> ratingModelFromJson(String str) => List<RatingModel>.from(json.decode(str).map((x) => RatingModel.fromJson(x)));

String ratingModelToJson(List<RatingModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RatingModel {
    final String id;
    final String userId;
    final String productId;
    final double rating;
    final String description;
    final DateTime createdAt;
    final DateTime updatedAt;
    final UserModel user;
    final ProductModel product;

    RatingModel({
        required this.id,
        required this.userId,
        required this.productId,
        required this.rating,
        required this.description,
        required this.createdAt,
        required this.updatedAt,
        required this.user,
        required this.product,
    });

    RatingModel copyWith({
        String? id,
        String? userId,
        String? productId,
        double? rating,
        String? description,
        DateTime? createdAt,
        DateTime? updatedAt,
        UserModel? user,
        ProductModel? product,
    }) => 
        RatingModel(
            id: id ?? this.id,
            userId: userId ?? this.userId,
            productId: productId ?? this.productId,
            rating: rating ?? this.rating,
            description: description ?? this.description,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            user: user ?? this.user,
            product: product ?? this.product,
        );

    factory RatingModel.fromJson(Map<String, dynamic> json) => RatingModel(
        id: json["id"],
        userId: json["userId"],
        productId: json["productId"],
        rating: json["rating"]?.toDouble(),
        description: json["description"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        user: UserModel.fromJson(json["user"]),
        product: ProductModel.fromJson(json["product"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "productId": productId,
        "rating": rating,
        "description": description,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "user": user.toJson(),
        "product": product.toJson(),
    };
}
