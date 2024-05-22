// To parse this JSON data, do
//
//     final bidModel = bidModelFromJson(jsonString);

import 'dart:convert';

import 'package:ecoville/models/product_model.dart';
import 'package:ecoville/models/user_model.dart';

List<BidModel> bidModelFromJson(String str) => List<BidModel>.from(json.decode(str).map((x) => BidModel.fromJson(x)));

String bidModelToJson(List<BidModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BidModel {
    final String id;
    final String productId;
    final String userId;
    final int price;
    final DateTime createdAt;
    final DateTime updatedAt;
    final UserModel user;
    final ProductModel product;

    BidModel({
        required this.id,
        required this.productId,
        required this.userId,
        required this.price,
        required this.createdAt,
        required this.updatedAt,
        required this.user,
        required this.product,
    });

    BidModel copyWith({
        String? id,
        String? productId,
        String? userId,
        int? price,
        DateTime? createdAt,
        DateTime? updatedAt,
        UserModel? user,
        ProductModel? product,
    }) => 
        BidModel(
            id: id ?? this.id,
            productId: productId ?? this.productId,
            userId: userId ?? this.userId,
            price: price ?? this.price,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            user: user ?? this.user,
            product: product ?? this.product,
        );

    factory BidModel.fromJson(Map<String, dynamic> json) => BidModel(
        id: json["id"],
        productId: json["productId"],
        userId: json["userId"],
        price: json["price"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        user: UserModel.fromJson(json["ecoville_user"]),
        product: ProductModel.fromJson(json["ecoville_product"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "productId": productId,
        "userId": userId,
        "price": price,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "ecoville_user": user.toJson(),
        "ecoville_product": product.toJson(),
    };
}
