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
  final int price;
  final List<String> image;
  final String categoryId;
  final Address address;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserModel user;
  final Category category;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.categoryId,
    required this.address,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.category,
  });

  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    int? price,
    List<String>? image,
    String? categoryId,
    Address? address,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
    UserModel? user,
    Category? category,
  }) =>
      ProductModel(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        price: price ?? this.price,
        image: image ?? this.image,
        categoryId: categoryId ?? this.categoryId,
        address: address ?? this.address,
        userId: userId ?? this.userId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        user: user ?? this.user,
        category: category ?? this.category,
      );

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        price: json["price"],
        image: List<String>.from(json["image"].map((x) => x)),
        categoryId: json["categoryId"],
        address: Address.fromJson(json["address"]),
        userId: json["userId"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        user: UserModel.fromJson(json["user"]),
        category: Category.fromJson(json["category"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "price": price,
        "image": List<dynamic>.from(image.map((x) => x)),
        "categoryId": categoryId,
        "address": address.toJson(),
        "userId": userId,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "user": user.toJson(),
        "category": category.toJson(),
      };
}

class Address {
  final double lat;
  final double lon;
  final String city;
  final String country;

  Address({
    required this.lat,
    required this.lon,
    required this.city,
    required this.country,
  });

  Address copyWith({
    double? lat,
    double? lon,
    String? city,
    String? country,
  }) =>
      Address(
        lat: lat ?? this.lat,
        lon: lon ?? this.lon,
        city: city ?? this.city,
        country: country ?? this.country,
      );

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        lat: json["lat"]?.toDouble(),
        lon: json["lon"]?.toDouble(),
        city: json["city"],
        country: json["country"],
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lon": lon,
        "city": city,
        "country": country,
      };
}

class Category {
  final String id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });

  Category copyWith({
    String? id,
    String? name,
  }) =>
      Category(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}