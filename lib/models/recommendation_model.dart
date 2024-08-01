// To parse this JSON data, do
//
//     final recommendationModel = recommendationModelFromJson(jsonString);

import 'dart:convert';

List<RecommendationModel> recommendationModelFromJson(String str) => List<RecommendationModel>.from(json.decode(str).map((x) => RecommendationModel.fromJson(x)));

String recommendationModelToJson(List<RecommendationModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RecommendationModel {
    final String id;
    final String name;
    final String description;
    final List<String> image;
    final int price;

    RecommendationModel({
        required this.id,
        required this.name,
        required this.description,
        required this.image,
        required this.price,
    });

    RecommendationModel copyWith({
        String? id,
        String? name,
        String? description,
        List<String>? image,
        int? price,
    }) => 
        RecommendationModel(
            id: id ?? this.id,
            name: name ?? this.name,
            description: description ?? this.description,
            image: image ?? this.image,
            price: price ?? this.price,
        );

    factory RecommendationModel.fromJson(Map<String, dynamic> json) => RecommendationModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        image: List<String>.from(json["image"].map((x) => x)),
        price: json["price"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "image": List<dynamic>.from(image.map((x) => x)),
        "price": price,
    };
}
