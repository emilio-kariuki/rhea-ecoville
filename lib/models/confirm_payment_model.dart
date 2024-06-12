// To parse this JSON data, do
//
//     final confirmPaymentModel = confirmPaymentModelFromJson(jsonString);

import 'dart:convert';

ConfirmPaymentModel confirmPaymentModelFromJson(String str) => ConfirmPaymentModel.fromJson(json.decode(str));

String confirmPaymentModelToJson(ConfirmPaymentModel data) => json.encode(data.toJson());

class ConfirmPaymentModel {
    final String responseCode;
    final String responseDescription;
    final String merchantRequestId;
    final String checkoutRequestId;
    final String resultCode;
    final String resultDesc;

    ConfirmPaymentModel({
        required this.responseCode,
        required this.responseDescription,
        required this.merchantRequestId,
        required this.checkoutRequestId,
        required this.resultCode,
        required this.resultDesc,
    });

    ConfirmPaymentModel copyWith({
        String? responseCode,
        String? responseDescription,
        String? merchantRequestId,
        String? checkoutRequestId,
        String? resultCode,
        String? resultDesc,
    }) => 
        ConfirmPaymentModel(
            responseCode: responseCode ?? this.responseCode,
            responseDescription: responseDescription ?? this.responseDescription,
            merchantRequestId: merchantRequestId ?? this.merchantRequestId,
            checkoutRequestId: checkoutRequestId ?? this.checkoutRequestId,
            resultCode: resultCode ?? this.resultCode,
            resultDesc: resultDesc ?? this.resultDesc,
        );

    factory ConfirmPaymentModel.fromJson(Map<String, dynamic> json) => ConfirmPaymentModel(
        responseCode: json["ResponseCode"],
        responseDescription: json["ResponseDescription"],
        merchantRequestId: json["MerchantRequestID"],
        checkoutRequestId: json["CheckoutRequestID"],
        resultCode: json["ResultCode"],
        resultDesc: json["ResultDesc"],
    );

    Map<String, dynamic> toJson() => {
        "ResponseCode": responseCode,
        "ResponseDescription": responseDescription,
        "MerchantRequestID": merchantRequestId,
        "CheckoutRequestID": checkoutRequestId,
        "ResultCode": resultCode,
        "ResultDesc": resultDesc,
    };
}
