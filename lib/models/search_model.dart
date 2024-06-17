// To parse this JSON data, do
//
//     final searchModel = searchModelFromJson(jsonString);

import 'dart:convert';

List<SearchModel> searchModelFromJson(String str) => List<SearchModel>.from(json.decode(str).map((x) => SearchModel.fromJson(x)));

String searchModelToJson(List<SearchModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SearchModel {
    final String id;
    final String name;

    SearchModel({
        required this.id,
        required this.name,
    });

    SearchModel copyWith({
        String? id,
        String? name,
    }) => 
        SearchModel(
            id: id ?? this.id,
            name: name ?? this.name,
        );

    factory SearchModel.fromJson(Map<String, dynamic> json) => SearchModel(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
