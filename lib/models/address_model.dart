import 'dart:convert';

class AddressRequestModel {
  final String name;
  final String email;
  final String phone;
  final String altPhone;
  final String region;
  final String city;
  final String country;
  final String additionalInformation;
  final String address;

  AddressRequestModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.altPhone,
    required this.city,
    required this.country,
    required this.additionalInformation,
    required this.region,
    required this.address,
  });

  factory AddressRequestModel.fromJson(Map<String, dynamic> json) =>
      AddressRequestModel(
        name: json['name'],
        email: json['email'],
        phone: json['phone'],
        altPhone: json['altPhone'],
        city: json['city'],
        country: json['country'],
        additionalInformation: json['additionalInformation'],
        region: json['region'],
        address: json['address'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'phone': phone,
        'altPhone': altPhone,
        'region': region,
        'city': city,
        'country': country,
        'additionalInformation': additionalInformation,
        'address': address,
      };
}

// To parse this JSON data, do
//
//     final addressModel = addressModelFromJson(jsonString);

List<AddressModel> addressModelFromJson(String str) => List<AddressModel>.from(
    json.decode(str).map((x) => AddressModel.fromJson(x)));

String addressModelToJson(List<AddressModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AddressModel {
  final String id;
  final String userId;
  final String name;
  final String phone;
  final String altPhone;
  final String email;
  final String region;
  final String city;
  final String country;
  final String additionalInformation;
  final String address;
  final DateTime createdAt;
  final DateTime updatedAt;

  AddressModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.phone,
    required this.altPhone,
    required this.email,
    required this.region,
    required this.city,
    required this.country,
    required this.additionalInformation,
    required this.address,
    required this.createdAt,
    required this.updatedAt,

  });

  AddressModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? phone,
    String? altPhone,
    String? email,
    String? region,
    String? city,
    String? country,
    String? additionalInformation,
    String? address,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      AddressModel(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        altPhone: altPhone ?? this.altPhone,
        email: email ?? this.email,
        region: region ?? this.region,
        city: city ?? this.city,
        country: country ?? this.country,
        additionalInformation:
            additionalInformation ?? this.additionalInformation,
        address: address ?? this.address,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        id: json["id"],
        userId: json["userId"],
        name: json["name"],
        phone: json["phone"],
        altPhone: json["altPhone"],
        email: json["email"],
        region: json["region"],
        city: json["city"],
        country: json["country"],
        additionalInformation: json["additionalInformation"],
        address: json["address"],
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
        "country": country,
        "additionalInformation": additionalInformation,
        "address": address,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
