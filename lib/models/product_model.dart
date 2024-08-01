// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

List<ProductModel> productModelFromJson(String str) => List<ProductModel>.from(json.decode(str).map((x) => ProductModel.fromJson(x)));

String productModelToJson(List<ProductModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductModel {
    final String id;
    final String name;
    final String? description;
    final List<String> image;
    final Address? address;
    final String? userId;
    final String? categoryId;
    final int? quantity;
    final bool? allowBidding;
    final bool? sold;
    final dynamic price;
    final dynamic biddingPrice;
    final int? likes;
    final bool isLiked;
    final bool isWishlisted;
    final bool isSaved;
    final String? condition;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final DateTime? startBidding;
    final DateTime? endBidding;
    final String? biddingStatus;
    final User? user;
    final Category? category;

    ProductModel({
        required this.id,
        required this.name,
        this.description,
        required this.image,
        this.address,
        this.userId,
        this.categoryId,
        this.quantity,
        this.allowBidding,
        this.sold,
        this.price,
        this.biddingPrice,
        this.likes,
        required this.isLiked,
        required this.isWishlisted,
        required this.isSaved,
        this.condition,
        this.createdAt,
        this.updatedAt,
        this.user,
        this.category,
        this.startBidding,
        this.endBidding,
        this.biddingStatus,
    });

    ProductModel copyWith({
        String? id,
        String? name,
        String? description,
        List<String>? image,
        Address? address,
        String? userId,
        String? categoryId,
        int? quantity,
        bool? allowBidding,
        bool? sold,
        dynamic price,
        dynamic biddingPrice,
        int? likes,
        bool? isLiked,
        bool? isWishlisted,
        bool? isSaved,
        String? condition,
        DateTime? createdAt,
        DateTime? updatedAt,
        User? user,
        Category? category,
        DateTime? startBidding,
        DateTime? endBidding,
        String? biddingStatus,
    }) => 
        ProductModel(
            id: id ?? this.id,
            name: name ?? this.name,
            description: description ?? this.description,
            image: image ?? this.image,
            address: address ?? this.address,
            userId: userId ?? this.userId,
            categoryId: categoryId ?? this.categoryId,
            quantity: quantity ?? this.quantity,
            allowBidding: allowBidding ?? this.allowBidding,
            sold: sold ?? this.sold,
            price: price ?? this.price,
            biddingPrice: biddingPrice ?? this.biddingPrice,
            likes: likes ?? this.likes,
            isLiked: isLiked ?? this.isLiked,
            isWishlisted: isWishlisted ?? this.isWishlisted,
            isSaved: isSaved ?? this.isSaved,
            condition: condition ?? this.condition,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            user: user ?? this.user,
            category: category ?? this.category,
            startBidding: startBidding ?? this.startBidding,
            endBidding: endBidding ?? this.endBidding,
            biddingStatus: biddingStatus ?? this.biddingStatus,
        );

    factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        image: json["image"] == null ? [] : List<String>.from(json["image"]!.map((x) => x)),
        address: json["address"] == null ? null : Address.fromJson(json["address"]),
        userId: json["userId"],
        categoryId: json["categoryId"],
        quantity: json["quantity"],
        allowBidding: json["allowBidding"],
        sold: json["sold"],
        price: json["price"],
        biddingPrice: json["biddingPrice"],
        likes: json["likes"],
        isLiked: json["isLiked"],
        isWishlisted: json["isWishlisted"],
        isSaved: json["isSaved"],
        condition: json["condition"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        category: json["category"] == null ? null : Category.fromJson(json["category"]),
        startBidding: json["startBidding"] == null ? null : DateTime.parse(json["startBidding"]),
        endBidding: json["endBidding"] == null ? null : DateTime.parse(json["endBidding"]),
        biddingStatus: json["biddingStatus"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "image": image == null ? [] : List<dynamic>.from(image.map((x) => x)),
        "address": address?.toJson(),
        "userId": userId,
        "categoryId": categoryId,
        "quantity": quantity,
        "allowBidding": allowBidding,
        "sold": sold,
        "price": price,
        "biddingPrice": biddingPrice,
        "likes": likes,
        "isLiked": isLiked,
        "isWishlisted": isWishlisted,
        "isSaved": isSaved,
        "condition": condition,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "user": user?.toJson(),
        "category": category?.toJson(),
        "startBidding": startBidding?.toIso8601String(),
        "endBidding": endBidding?.toIso8601String(),
        "biddingStatus": biddingStatus,
    };
}

class Address {
    final dynamic lon;
    final dynamic lat;
    final String? city;
    final String? country;

    Address({
        this.lon,
        this.lat,
        this.city,
        this.country,
    });

    Address copyWith({
        dynamic lon,
        dynamic lat,
        String? city,
        String? country,
    }) => 
        Address(
            lon: lon ?? this.lon,
            lat: lat ?? this.lat,
            city: city ?? this.city,
            country: country ?? this.country,
        );

    factory Address.fromJson(Map<String, dynamic> json) => Address(
        lon: json["lon"],
        lat: json["lat"],
        city: json["city"],
        country: json["country"],
    );

    Map<String, dynamic> toJson() => {
        "lon": lon,
        "lat": lat,
        "city": city,
        "country": country,
    };
}

class Category {
    final String? id;
    final String? name;
    final String? image;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    Category({
        this.id,
        this.name,
        this.image,
        this.createdAt,
        this.updatedAt,
    });

    Category copyWith({
        String? id,
        String? name,
        String? image,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        Category(
            id: id ?? this.id,
            name: name ?? this.name,
            image: image ?? this.image,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
    };
}

class User {
    final String? id;
    final String? name;
    final String? email;
    final String? phone;
    final String? image;
    final String? token;
    final Rating? rating;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    User({
        this.id,
        this.name,
        this.email,
        this.phone,
        this.image,
        this.token,
        this.rating,
        this.createdAt,
        this.updatedAt,
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
        rating: json["rating"] == null ? null : Rating.fromJson(json["rating"]),
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "image": image,
        "token": token,
        "rating": rating?.toJson(),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
    };
}

class Rating {
    final double? description;
    final double? communication;
    final double? shipping;

    Rating({
        this.description,
        this.communication,
        this.shipping,
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
