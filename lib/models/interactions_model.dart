// To parse this JSON data, do
//
//     final interactionsModel = interactionsModelFromJson(jsonString);

import 'dart:convert';

List<InteractionsModel> interactionsModelFromJson(String str) => List<InteractionsModel>.from(json.decode(str).map((x) => InteractionsModel.fromJson(x)));

String interactionsModelToJson(List<InteractionsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class InteractionsModel {
    final String id;
    final String productId;
    final String userId;
    final DateTime createdAt;
    final DateTime updatedAt;
    final User user;
    final Product product;

    InteractionsModel({
        required this.id,
        required this.productId,
        required this.userId,
        required this.createdAt,
        required this.updatedAt,
        required this.user,
        required this.product,
    });

    InteractionsModel copyWith({
        String? id,
        String? productId,
        String? userId,
        DateTime? createdAt,
        DateTime? updatedAt,
        User? user,
        Product? product,
    }) => 
        InteractionsModel(
            id: id ?? this.id,
            productId: productId ?? this.productId,
            userId: userId ?? this.userId,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            user: user ?? this.user,
            product: product ?? this.product,
        );

    factory InteractionsModel.fromJson(Map<String, dynamic> json) => InteractionsModel(
        id: json["id"],
        productId: json["productId"],
        userId: json["userId"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        user: User.fromJson(json["user"]),
        product: Product.fromJson(json["product"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "productId": productId,
        "userId": userId,
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
    final List<String> image;
    final Address address;
    final String userId;
    final String categoryId;
    final int quantity;
    final bool allowBidding;
    final bool sold;
    final int price;
    final int likes;
    final bool isLiked;
    final bool isWishlisted;
    final bool isSaved;
    final String condition;
    final DateTime createdAt;
    final DateTime updatedAt;

    Product({
        required this.id,
        required this.name,
        required this.description,
        required this.image,
        required this.address,
        required this.userId,
        required this.categoryId,
        required this.quantity,
        required this.allowBidding,
        required this.sold,
        required this.price,
        required this.likes,
        required this.isLiked,
        required this.isWishlisted,
        required this.isSaved,
        required this.condition,
        required this.createdAt,
        required this.updatedAt,
    });

    Product copyWith({
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
        int? price,
        int? likes,
        bool? isLiked,
        bool? isWishlisted,
        bool? isSaved,
        String? condition,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        Product(
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
            likes: likes ?? this.likes,
            isLiked: isLiked ?? this.isLiked,
            isWishlisted: isWishlisted ?? this.isWishlisted,
            isSaved: isSaved ?? this.isSaved,
            condition: condition ?? this.condition,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        image: List<String>.from(json["image"].map((x) => x)),
        address: Address.fromJson(json["address"]),
        userId: json["userId"],
        categoryId: json["categoryId"],
        quantity: json["quantity"],
        allowBidding: json["allowBidding"],
        sold: json["sold"],
        price: json["price"],
        likes: json["likes"],
        isLiked: json["isLiked"],
        isWishlisted: json["isWishlisted"],
        isSaved: json["isSaved"],
        condition: json["condition"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "image": List<dynamic>.from(image.map((x) => x)),
        "address": address.toJson(),
        "userId": userId,
        "categoryId": categoryId,
        "quantity": quantity,
        "allowBidding": allowBidding,
        "sold": sold,
        "price": price,
        "likes": likes,
        "isLiked": isLiked,
        "isWishlisted": isWishlisted,
        "isSaved": isSaved,
        "condition": condition,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
    };
}

class Address {
    final String lon;
    final String lat;
    final String city;
    final String country;

    Address({
        required this.lon,
        required this.lat,
        required this.city,
        required this.country,
    });

    Address copyWith({
        String? lon,
        String? lat,
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
