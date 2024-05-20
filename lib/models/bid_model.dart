// To parse this JSON data, do
//
//     final bidModel = bidModelFromJson(jsonString);

import 'dart:convert';

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
    final Product product;

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
        Product? product,
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
        user: UserModel.fromJson(json["user"]),
        product: Product.fromJson(json["product"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "productId": productId,
        "userId": userId,
        "price": price,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "user": user.toJson(),
        "product": product.toJson(),
    };
}

class Product {
    final String id;
    final String name;
    final String description;
    final int price;
    final List<String> image;
    final Address address;
    final String categoryId;
    final String userId;
    final DateTime createdAt;
    final String updatedAt;

    Product({
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
    });

    Product copyWith({
        String? id,
        String? name,
        String? description,
        int? price,
        List<String>? image,
        Address? address,
        String? categoryId,
        String? userId,
        DateTime? createdAt,
        String? updatedAt,
    }) => 
        Product(
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
        );

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        price: json["price"],
        image: List<String>.from(json["image"].map((x) => x)),
        address: Address.fromJson(json["address"]),
        categoryId: json["categoryId"],
        userId: json["userId"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"],
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
        "updatedAt": updatedAt,
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
