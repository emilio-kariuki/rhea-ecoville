
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
    final String id;
    final String name;
    final String email;
    final String image;
    final String ?phone;
    final String token;
    final Rating ?rating;
    final DateTime ?createdAt;
    final DateTime ?updatedAt;
    final List<Address> ?addresses;

    UserModel({
        required this.id,
        required this.name,
        required this.email,
         this.phone,
        required this.image,
        required this.token,
         this.rating,
         this.createdAt,
         this.updatedAt,
         this.addresses,
    });

    UserModel copyWith({
        String? id,
        String? name,
        String? email,
        String? phone,
        String? image,
        String? token,
        Rating? rating,
        DateTime? createdAt,
        DateTime? updatedAt,
        List<Address>? addresses,
    }) => 
        UserModel(
            id: id ?? this.id,
            name: name ?? this.name,
            email: email ?? this.email,
            phone: phone ?? this.phone,
            image: image ?? this.image,
            token: token ?? this.token,
            rating: rating ?? this.rating,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            addresses: addresses ?? this.addresses,
        );

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        image: json["image"],
        token: json["token"],
        rating: Rating.fromJson(json["rating"]),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        addresses: List<Address>.from(json["addresses"].map((x) => Address.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "image": image,
        "token": token,
        "rating": rating!.toJson(),
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "addresses": List<dynamic>.from(addresses!.map((x) => x.toJson())),
    };
}

class Address {
    final String userId;
    final String name;
    final String phone;
    final String altPhone;
    final String email;
    final String region;
    final String city;
    final String additionalInformation;
    final DateTime createdAt;
    final DateTime updatedAt;

    Address({
        required this.userId,
        required this.name,
        required this.phone,
        required this.altPhone,
        required this.email,
        required this.region,
        required this.city,
        required this.additionalInformation,
        required this.createdAt,
        required this.updatedAt,
    });

    Address copyWith({
        String? id,
        String? userId,
        String? name,
        String? phone,
        String? altPhone,
        String? email,
        String? region,
        String? city,
        String? additionalInformation,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        Address(
            userId: userId ?? this.userId,
            name: name ?? this.name,
            phone: phone ?? this.phone,
            altPhone: altPhone ?? this.altPhone,
            email: email ?? this.email,
            region: region ?? this.region,
            city: city ?? this.city,
            additionalInformation: additionalInformation ?? this.additionalInformation,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory Address.fromJson(Map<String, dynamic> json) => Address(
        userId: json["userId"],
        name: json["name"],
        phone: json["phone"],
        altPhone: json["altPhone"],
        email: json["email"],
        region: json["region"],
        city: json["city"],
        additionalInformation: json["additionalInformation"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "userId": userId,
        "name": name,
        "phone": phone,
        "altPhone": altPhone,
        "email": email,
        "region": region,
        "city": city,
        "additionalInformation": additionalInformation,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
    };
}

class Rating {
    final double description;
    final double communication;
    final double shipping;

    Rating({
        required this.description,
        required this.communication,
        required this.shipping,
    });

    Rating copyWith({
        double? description,
        double? communication,
        double? shipping,
    }) => 
        Rating(
            description: description ?? this.description,
            communication: communication ?? this.communication,
            shipping: shipping ?? this.shipping,
        );

    factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        description: json["description"]?.toDouble(),
        communication: json["communication"]?.toDouble(),
        shipping: json["shipping"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "description": description,
        "communication": communication,
        "shipping": shipping,
    };
}

