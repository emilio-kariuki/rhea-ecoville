// To parse this JSON data, do
//
//     final titleDescriptionModel = titleDescriptionModelFromJson(jsonString);

import 'dart:convert';

TitleDescriptionModel titleDescriptionModelFromJson(String str) => TitleDescriptionModel.fromJson(json.decode(str));

String titleDescriptionModelToJson(TitleDescriptionModel data) => json.encode(data.toJson());

class TitleDescriptionModel {
    final String title;
    final String description;

    TitleDescriptionModel({
        required this.title,
        required this.description,
    });

    TitleDescriptionModel copyWith({
        String? title,
        String? description,
    }) => 
        TitleDescriptionModel(
            title: title ?? this.title,
            description: description ?? this.description,
        );

    factory TitleDescriptionModel.fromJson(Map<String, dynamic> json) => TitleDescriptionModel(
        title: json["title"],
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
    };
}
