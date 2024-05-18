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

    UserModel({
        required this.id,
        required this.name,
        required this.email,
        this.phone,
        required this.image,
        required this.token,
         this.address,
    });

    UserModel copyWith({
        String? id,
        String? name,
        String? email,
        String? phone,
        String? image,
        String? token,
        Address? address,
    }) => 
        UserModel(
            id: id ?? this.id,
            name: name ?? this.name,
            email: email ?? this.email,
            phone: phone ?? this.phone,
            image: image ?? this.image,
            token: token ?? this.token,
            address: address ?? this.address,
        );

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        image: json["image"],
        token: json["token"],
        address: Address.fromJson(json["address"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "image": image,
        "token": token,
        "address": address!.toJson(),
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
