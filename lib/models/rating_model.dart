// To parse this JSON data, do
//
//     final ratingModel = ratingModelFromJson(jsonString);

import 'dart:convert';

List<RatingModel> ratingModelFromJson(String str) => List<RatingModel>.from(json.decode(str).map((x) => RatingModel.fromJson(x)));

String ratingModelToJson(List<RatingModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RatingModel {
    final String id;
    final String userId;
    final String sellerId;
    final String productId;
    final double rating;
    final String review;
    final DateTime createdAt;
    final DateTime updatedAt;
    final User user;

    RatingModel({
        required this.id,
        required this.userId,
        required this.sellerId,
        required this.productId,
        required this.rating,
        required this.review,
        required this.createdAt,
        required this.updatedAt,
        required this.user,
    });

    RatingModel copyWith({
        String? id,
        String? userId,
        String? sellerId,
        String? productId,
        double? rating,
        String? review,
        DateTime? createdAt,
        DateTime? updatedAt,
        User? user,
    }) => 
        RatingModel(
            id: id ?? this.id,
            userId: userId ?? this.userId,
            sellerId: sellerId ?? this.sellerId,
            productId: productId ?? this.productId,
            rating: rating ?? this.rating,
            review: review ?? this.review,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            user: user ?? this.user,
        );

    factory RatingModel.fromJson(Map<String, dynamic> json) => RatingModel(
        id: json["id"],
        userId: json["userId"],
        sellerId: json["sellerId"],
        productId: json["productId"],
        rating: json["rating"]?.toDouble(),
        review: json["review"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        user: User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "sellerId": sellerId,
        "productId": productId,
        "rating": rating,
        "review": review,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "user": user.toJson(),
    };
}

class User {
    final String id;
    final String name;
    final String email;
    final String phone;
    final String image;
    final String token;
    final Rating rating;
    final DateTime createdAt;
    final DateTime updatedAt;

    User({
        required this.id,
        required this.name,
        required this.email,
        required this.phone,
        required this.image,
        required this.token,
        required this.rating,
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
        Rating? rating,
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
            rating: rating ?? this.rating,
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
        rating: Rating.fromJson(json["rating"]),
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
        "rating": rating.toJson(),
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
