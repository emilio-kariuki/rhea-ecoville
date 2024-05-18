// To parse this JSON data, do
//
//     final biddingModel = biddingModelFromJson(jsonString);

import 'dart:convert';

List<BiddingModel> biddingModelFromJson(String str) => List<BiddingModel>.from(json.decode(str).map((x) => BiddingModel.fromJson(x)));

String biddingModelToJson(List<BiddingModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BiddingModel {
    final String id;
    final String productId;
    final String userId;
    final int price;
    final DateTime createdAt;
    final DateTime updatedAt;
    final User user;
    final Product product;

    BiddingModel({
        required this.id,
        required this.productId,
        required this.userId,
        required this.price,
        required this.createdAt,
        required this.updatedAt,
        required this.user,
        required this.product,
    });

    BiddingModel copyWith({
        String? id,
        String? productId,
        String? userId,
        int? price,
        DateTime? createdAt,
        DateTime? updatedAt,
        User? user,
        Product? product,
    }) => 
        BiddingModel(
            id: id ?? this.id,
            productId: productId ?? this.productId,
            userId: userId ?? this.userId,
            price: price ?? this.price,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            user: user ?? this.user,
            product: product ?? this.product,
        );

    factory BiddingModel.fromJson(Map<String, dynamic> json) => BiddingModel(
        id: json["id"],
        productId: json["productId"],
        userId: json["userId"],
        price: json["price"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        user: User.fromJson(json["user"]),
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
    final String userId;
    final DateTime createdAt;
    final DateTime updatedAt;

    Product({
        required this.id,
        required this.name,
        required this.description,
        required this.price,
        required this.image,
        required this.address,
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
        String? userId,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        Product(
            id: id ?? this.id,
            name: name ?? this.name,
            description: description ?? this.description,
            price: price ?? this.price,
            image: image ?? this.image,
            address: address ?? this.address,
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
        userId: json["userId"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "price": price,
        "image": List<dynamic>.from(image.map((x) => x)),
        "address": address.toJson(),
        "userId": userId,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
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

class User {
    final String id;
    final String name;
    final String email;
    final String phone;
    final String image;
    final String token;
    final Address address;
    final DateTime createdAt;
    final DateTime updatedAt;

    User({
        required this.id,
        required this.name,
        required this.email,
        required this.phone,
        required this.image,
        required this.token,
        required this.address,
        required this.createdAt,
        required this.updatedAt,
    });

    User copyWith({
        String? id,
        String? name,
        String? email,
        String? phone,
        String? image,
        String? token,
        Address? address,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        User(
            id: id ?? this.id,
            name: name ?? this.name,
            email: email ?? this.email,
            phone: phone ?? this.phone,
            image: image ?? this.image,
            token: token ?? this.token,
            address: address ?? this.address,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        image: json["image"],
        token: json["token"],
        address: Address.fromJson(json["address"]),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "image": image,
        "token": token,
        "address": address.toJson(),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
    };
}
