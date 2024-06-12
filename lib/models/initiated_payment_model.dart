// To parse this JSON data, do
//
//     final initiatedPaymentModel = initiatedPaymentModelFromJson(jsonString);

import 'dart:convert';

InitiatedPaymentModel initiatedPaymentModelFromJson(String str) => InitiatedPaymentModel.fromJson(json.decode(str));

String initiatedPaymentModelToJson(InitiatedPaymentModel data) => json.encode(data.toJson());

class InitiatedPaymentModel {
    final String merchantRequestId;
    final String checkoutRequestId;
    final String responseCode;
    final String responseDescription;
    final String customerMessage;

    InitiatedPaymentModel({
        required this.merchantRequestId,
        required this.checkoutRequestId,
        required this.responseCode,
        required this.responseDescription,
        required this.customerMessage,
    });

    InitiatedPaymentModel copyWith({
        String? merchantRequestId,
        String? checkoutRequestId,
        String? responseCode,
        String? responseDescription,
        String? customerMessage,
    }) => 
        InitiatedPaymentModel(
            merchantRequestId: merchantRequestId ?? this.merchantRequestId,
            checkoutRequestId: checkoutRequestId ?? this.checkoutRequestId,
            responseCode: responseCode ?? this.responseCode,
            responseDescription: responseDescription ?? this.responseDescription,
            customerMessage: customerMessage ?? this.customerMessage,
        );

    factory InitiatedPaymentModel.fromJson(Map<String, dynamic> json) => InitiatedPaymentModel(
        merchantRequestId: json["MerchantRequestID"],
        checkoutRequestId: json["CheckoutRequestID"],
        responseCode: json["ResponseCode"],
        responseDescription: json["ResponseDescription"],
        customerMessage: json["CustomerMessage"],
    );

    Map<String, dynamic> toJson() => {
        "MerchantRequestID": merchantRequestId,
        "CheckoutRequestID": checkoutRequestId,
        "ResponseCode": responseCode,
        "ResponseDescription": responseDescription,
        "CustomerMessage": customerMessage,
    };
}
