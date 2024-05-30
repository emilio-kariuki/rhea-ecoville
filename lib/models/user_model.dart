// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

List<UserModel> userModelFromJson(String str) => List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));

String userModelToJson(List<UserModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserModel {
    final String id;
    final String name;
    final String email;
    final String ?phone;
    final String image;
    final String token;
    final Address ?address;
    final DateTime ?createdAt;
    final UserRating ?rating;

    UserModel({
        required this.id,
        required this.name,
        required this.email,
        required this.image,
        required this.token,
        this.phone,
        this.address,
        this.createdAt,
        this.rating,
    });

    UserModel copyWith({
        String? id,
        String? name,
        String? email,
        String? phone,
        String? image,
        String? token,
        Address? address,
        DateTime? createdAt,
        UserRating? rating,
    }) => 
        UserModel(
            id: id ?? this.id,
            name: name ?? this.name,
            email: email ?? this.email,
            phone: phone ?? this.phone,
            image: image ?? this.image,
            token: token ?? this.token,
            address: address ?? this.address,
            createdAt: createdAt ?? this.createdAt,
            rating: rating ?? this.rating,
        );

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        image: json["image"],
        token: json["token"],
        address: Address.fromJson(json["address"]),
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        rating: json["rating"] == null ? null : UserRating.fromJson(json["rating"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "image": image,
        "token": token,
        "address": address!.toJson(),
        "createdAt": createdAt?.toIso8601String(),
        "rating": rating?.toJson(),
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


UserRating userRatingFromJson(String str) => UserRating.fromJson(json.decode(str));

String userRatingToJson(UserRating data) => json.encode(data.toJson());

class UserRating {
    final double description;
    final double shipping;
    final double communication;

    UserRating({
        required this.description,
        required this.shipping,
        required this.communication,
    });

    UserRating copyWith({
        double? description,
        double? shipping,
        double? communication,
    }) => 
        UserRating(
            description: description ?? this.description,
            shipping: shipping ?? this.shipping,
            communication: communication ?? this.communication,
        );

    factory UserRating.fromJson(Map<String, dynamic> json) => UserRating(
        description: json["description"],
        shipping: json["shipping"],
        communication: json["communication"],
    );

    Map<String, dynamic> toJson() => {
        "description": description,
        "shipping": shipping,
        "communication": communication,
    };
}
