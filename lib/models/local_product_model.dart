// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';


List<LocalProductModel> productModelFromJson(String str) => List<LocalProductModel>.from(
    json.decode(str).map((x) => LocalProductModel.fromJson(x)));

String productModelToJson(List<LocalProductModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LocalProductModel {
  final String id;
  final String name;
  final String image;
  final String userId;
  final double startingPrice;

  LocalProductModel({
    required this.id,
    required this.name,
    required this.image,
    required this.userId,
    required this.startingPrice,
  });

  LocalProductModel copyWith({
    String? id,
    String? name,
    String? image,
    String? userId,
    double? startingPrice,
  }) =>
      LocalProductModel(
        id: id ?? this.id,
        name: name ?? this.name,
        image: image ?? this.image,
        userId: userId ?? this.userId,
        startingPrice: startingPrice ?? this.startingPrice,
      );

  factory LocalProductModel.fromJson(Map<String, dynamic> json) => LocalProductModel(
        id: json["id"],
        name: json["name"],
        image: json['image'],
        userId: json["userId"],
        startingPrice: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "userId": userId,
        "price": startingPrice,
      };
}
