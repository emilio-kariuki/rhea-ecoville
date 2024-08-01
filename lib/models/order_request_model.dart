// To parse this JSON data, do
//
//     final orderRequestModel = orderRequestModelFromJson(jsonString);

import 'dart:convert';

OrderRequestModel orderRequestModelFromJson(String str) => OrderRequestModel.fromJson(json.decode(str));

String orderRequestModelToJson(OrderRequestModel data) => json.encode(data.toJson());

class OrderRequestModel {
    final String productId;
    final int quantity;
    final int price;

    OrderRequestModel({
        required this.productId,
        required this.quantity,
        required this.price,
    });

    OrderRequestModel copyWith({
        String? productId,
        int? quantity,
        int? price,
    }) => 
        OrderRequestModel(
            productId: productId ?? this.productId,
            quantity: quantity ?? this.quantity,
            price: price ?? this.price,
        );

    factory OrderRequestModel.fromJson(Map<String, dynamic> json) => OrderRequestModel(
        productId: json["productId"],
        quantity: json["quantity"],
        price: json["price"],
    );

    Map<String, dynamic> toJson() => {
        "productId": productId,
        "quantity": quantity,
        "price": price,
    };
}
