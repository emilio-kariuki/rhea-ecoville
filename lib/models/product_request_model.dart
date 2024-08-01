// To parse this JSON data, do
//
//     final productRequestModel = productRequestModelFromJson(jsonString);

import 'dart:convert';

import 'package:ecoville/models/user_model.dart';

ProductRequestModel productRequestModelFromJson(String str) => ProductRequestModel.fromJson(json.decode(str));

String productRequestModelToJson(ProductRequestModel data) => json.encode(data.toJson());

class ProductRequestModel {
    final String id;
    final String name;
    final String description;
    final List<String> image;
    final String userId;
    final String categoryid;
    final double price;
    final double currentPrice;
    final String condition;
    final Address ?address;

    ProductRequestModel({
        required this.id,
        required this.name,
        required this.description,
        required this.image,
        required this.userId,
        required this.categoryid,
        required this.price,
        required this.currentPrice,
        required this.condition,
         this.address,
    });

    ProductRequestModel copyWith({
        String? id,
        String? name,
        String? description,
        List<String>? image,
        String? userId,
        String? categoryid,
        double? price,
        double? currentPrice,
        String? condition,
        Address? address,
    }) => 
        ProductRequestModel(
            id: id ?? this.id,
            name: name ?? this.name,
            description: description ?? this.description,
            image: image ?? this.image,
            userId: userId ?? this.userId,
            categoryid: categoryid ?? this.categoryid,
            price: price ?? this.price,
            currentPrice: currentPrice ?? this.currentPrice,
            condition: condition ?? this.condition,
            address: address ?? this.address,
        );

    factory ProductRequestModel.fromJson(Map<String, dynamic> json) => ProductRequestModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        image: List<String>.from(json["image"].map((x) => x)),
        userId: json["userId"],
        categoryid: json["categoryId"],
        price: json["price"]?.toDouble(),
        currentPrice: json["currentPrice"]?.toDouble(),
        condition: json["condition"],
        address: Address.fromJson(json["address"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "image": List<dynamic>.from(image.map((x) => x)),
        "userId": userId,
        "categoryId": categoryid,
        "price": price,
        "currentPrice": currentPrice,
        "condition": condition,
        "address": address!.toJson(),
    };
}
