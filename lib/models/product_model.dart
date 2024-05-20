// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

import 'package:ecoville/models/user_model.dart';

List<ProductModel> productModelFromJson(String str) => List<ProductModel>.from(json.decode(str).map((x) => ProductModel.fromJson(x)));

String productModelToJson(List<ProductModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductModel {
    final String id;
    final String name;
    final String description;
    final int price;
    final List<String> image;
    final Address address;
    final String categoryId;
    final String userId;
    final DateTime createdAt;
    final DateTime updatedAt;
    final UserModel ?user;
    final Category ?category;

    ProductModel({
        required this.id,
        required this.name,
        required this.description,
        required this.price,
        required this.image,
        required this.address,
        required this.categoryId,
        required this.userId,
        required this.createdAt,
        required this.updatedAt,
         this.user,
         this.category,
    });

    ProductModel copyWith({
        String? id,
        String? name,
        String? description,
        int? price,
        List<String>? image,
        Address? address,
        String? categoryId,
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
            address: address ?? this.address,
            categoryId: categoryId ?? this.categoryId,
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
        address: Address.fromJson(json["address"]),
        categoryId: json["categoryId"],
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
        "address": address.toJson(),
        "categoryId": categoryId,
        "userId": userId,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "user": user!.toJson(),
        "category": category!.toJson(),
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
