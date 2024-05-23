// To parse this JSON data, do
//
//     final salesModel = salesModelFromJson(jsonString);

import 'dart:convert';

import 'package:ecoville/models/product_model.dart';
import 'package:ecoville/models/user_model.dart';

List<SalesModel> salesModelFromJson(String str) => List<SalesModel>.from(json.decode(str).map((x) => SalesModel.fromJson(x)));

String salesModelToJson(List<SalesModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SalesModel {
    final String id;
    final String productId;
    final String userId;
    final DateTime createdAt;
    final DateTime updatedAt;
    final UserModel user;
    final ProductModel product;

    SalesModel({
        required this.id,
        required this.productId,
        required this.userId,
        required this.createdAt,
        required this.updatedAt,
        required this.user,
        required this.product,
    });

    SalesModel copyWith({
        String? id,
        String? productId,
        String? userId,
        DateTime? createdAt,
        DateTime? updatedAt,
        UserModel? user,
        ProductModel? product,
    }) => 
        SalesModel(
            id: id ?? this.id,
            productId: productId ?? this.productId,
            userId: userId ?? this.userId,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            user: user ?? this.user,
            product: product ?? this.product,
        );

    factory SalesModel.fromJson(Map<String, dynamic> json) => SalesModel(
        id: json["id"],
        productId: json["productId"],
        userId: json["userId"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        user: UserModel.fromJson(json["user"]),
        product: ProductModel.fromJson(json["product"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "productId": productId,
        "userId": userId,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "user": user.toJson(),
        "product": product.toJson(),
    };
}

