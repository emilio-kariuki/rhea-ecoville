// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

import 'dart:convert';

CategoryModel categoryModelFromJson(String str) => CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
    final String id;
    final String name;
    final String image;

    CategoryModel({
        required this.id,
        required this.name,
        required this.image,
    });

    CategoryModel copyWith({
        String? id,
        String? name,
        String? image,
    }) => 
        CategoryModel(
            id: id ?? this.id,
            name: name ?? this.name,
            image: image ?? this.image,
        );

    factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json["id"],
        name: json["name"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
    };
}
