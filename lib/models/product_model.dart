// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

import 'package:ecoville/models/user_model.dart';

List<ProductModel> productModelFromJson(String str) => List<ProductModel>.from(
    json.decode(str).map((x) => ProductModel.fromJson(x)));

String productModelToJson(List<ProductModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductModel {
  final String id;
  final String name;
  final String description;
  final List<String> image;
  final Address address;
  final String categoryId;
  final String userId;
  final bool allowBidding;
  final int startingPrice;
  final int currentPrice;
  final DateTime startBiddingTime;
  final DateTime endBiddingTime;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserModel user;
  final Category category;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.address,
    required this.categoryId,
    required this.userId,
    required this.allowBidding,
    required this.startingPrice,
    required this.currentPrice,
    required this.startBiddingTime,
    required this.endBiddingTime,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.category,
  });

  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? image,
    Address? address,
    String? categoryId,
    String? userId,
    bool? allowBidding,
    int? startingPrice,
    int? currentPrice,
    DateTime? startBiddingTime,
    DateTime? endBiddingTime,
    DateTime? createdAt,
    DateTime? updatedAt,
    UserModel? user,
    Category? category,
  }) =>
      ProductModel(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        image: image ?? this.image,
        address: address ?? this.address,
        categoryId: categoryId ?? this.categoryId,
        userId: userId ?? this.userId,
        allowBidding: allowBidding ?? this.allowBidding,
        startingPrice: startingPrice ?? this.startingPrice,
        currentPrice: currentPrice ?? this.currentPrice,
        startBiddingTime: startBiddingTime ?? this.startBiddingTime,
        endBiddingTime: endBiddingTime ?? this.endBiddingTime,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        user: user ?? this.user,
        category: category ?? this.category,
      );

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        image: List<String>.from(json["image"].map((x) => x)),
        address: Address.fromJson(json["address"]),
        categoryId: json["categoryId"],
        userId: json["userId"],
        allowBidding: json["allowBidding"],
        startingPrice: json["startingPrice"],
        currentPrice: json["currentPrice"],
        startBiddingTime: DateTime.parse(json["startBiddingTime"]),
        endBiddingTime: DateTime.parse(json["endBiddingTime"]),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        user: UserModel.fromJson(json["ecoville_user"]),
        category: Category.fromJson(json["ecoville_category"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "image": List<dynamic>.from(image.map((x) => x)),
        "address": address.toJson(),
        "categoryId": categoryId,
        "userId": userId,
        "allowBidding": allowBidding,
        "startingPrice": startingPrice,
        "currentPrice": currentPrice,
        "startBiddingTime": startBiddingTime.toIso8601String(),
        "endBiddingTime": endBiddingTime.toIso8601String(),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "ecoville_user": user.toJson(),
        "ecoville_category": category.toJson(),
      };
}

class Category {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  Category({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  Category copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Category(
        id: id ?? this.id,
        name: name ?? this.name,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
