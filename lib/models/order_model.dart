// To parse this JSON data, do
//
//     final orderModel = orderModelFromJson(jsonString);

import 'dart:convert';

List<OrderModel> orderModelFromJson(String str) => List<OrderModel>.from(json.decode(str).map((x) => OrderModel.fromJson(x)));

String orderModelToJson(List<OrderModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrderModel {
    final String id;
    final String userId;
    final String productId;
    final int totalPrice;
    final int quantity;
    final String status;
    final DateTime createdAt;
    final DateTime updatedAt;
    final User user;
    final Product product;

    OrderModel({
        required this.id,
        required this.userId,
        required this.productId,
        required this.totalPrice,
        required this.quantity,
        required this.status,
        required this.createdAt,
        required this.updatedAt,
        required this.user,
        required this.product,
    });

    OrderModel copyWith({
        String? id,
        String? userId,
        String? productId,
        int? totalPrice,
        int? quantity,
        String? status,
        DateTime? createdAt,
        DateTime? updatedAt,
        User? user,
        Product? product,
    }) => 
        OrderModel(
            id: id ?? this.id,
            userId: userId ?? this.userId,
            productId: productId ?? this.productId,
            totalPrice: totalPrice ?? this.totalPrice,
            quantity: quantity ?? this.quantity,
            status: status ?? this.status,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            user: user ?? this.user,
            product: product ?? this.product,
        );

    factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json["id"],
        userId: json["userId"],
        productId: json["productId"],
        totalPrice: json["totalPrice"],
        quantity: json["quantity"],
        status: json["status"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        user: User.fromJson(json["user"]),
        product: Product.fromJson(json["product"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "productId": productId,
        "totalPrice": totalPrice,
        "quantity": quantity,
        "status": status,
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
    final ProductAddress address;
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
        ProductAddress? address,
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
        address: ProductAddress.fromJson(json["address"]),
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

class ProductAddress {
    final dynamic lon;
    final dynamic lat;
    final String city;
    final String country;

    ProductAddress({
        required this.lon,
        required this.lat,
        required this.city,
        required this.country,
    });

    ProductAddress copyWith({
        dynamic lon,
        dynamic lat,
        String? city,
        String? country,
    }) => 
        ProductAddress(
            lon: lon ?? this.lon,
            lat: lat ?? this.lat,
            city: city ?? this.city,
            country: country ?? this.country,
        );

    factory ProductAddress.fromJson(Map<String, dynamic> json) => ProductAddress(
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
    final List<AddressElement> addresses;

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
        required this.addresses,
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
        List<AddressElement>? addresses,
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
            addresses: addresses ?? this.addresses,
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
        addresses: List<AddressElement>.from(json["addresses"].map((x) => AddressElement.fromJson(x))),
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
        "addresses": List<dynamic>.from(addresses.map((x) => x.toJson())),
    };
}

class AddressElement {
    final String id;
    final String userId;
    final String name;
    final String phone;
    final String altPhone;
    final String email;
    final String region;
    final String city;
    final String address;
    final String additionalInformation;
    final DateTime createdAt;
    final DateTime updatedAt;

    AddressElement({
        required this.id,
        required this.userId,
        required this.name,
        required this.phone,
        required this.altPhone,
        required this.email,
        required this.region,
        required this.city,
        required this.address,
        required this.additionalInformation,
        required this.createdAt,
        required this.updatedAt,
    });

    AddressElement copyWith({
        String? id,
        String? userId,
        String? name,
        String? phone,
        String? altPhone,
        String? email,
        String? region,
        String? city,
        String? address,
        String? additionalInformation,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        AddressElement(
            id: id ?? this.id,
            userId: userId ?? this.userId,
            name: name ?? this.name,
            phone: phone ?? this.phone,
            altPhone: altPhone ?? this.altPhone,
            email: email ?? this.email,
            region: region ?? this.region,
            city: city ?? this.city,
            address: address ?? this.address,
            additionalInformation: additionalInformation ?? this.additionalInformation,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory AddressElement.fromJson(Map<String, dynamic> json) => AddressElement(
        id: json["id"],
        userId: json["userId"],
        name: json["name"],
        phone: json["phone"],
        altPhone: json["altPhone"],
        email: json["email"],
        region: json["region"],
        city: json["city"],
        address: json["address"],
        additionalInformation: json["additionalInformation"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "name": name,
        "phone": phone,
        "altPhone": altPhone,
        "email": email,
        "region": region,
        "city": city,
        "address": address,
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
