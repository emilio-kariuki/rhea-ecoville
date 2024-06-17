class AddressModel {
  final String id;
  final String name;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String country;
  final String postalCode;
  final String phone;
  final String primary;

  AddressModel({
    required this.id,
    required this.name,
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.country,
    required this.postalCode,
    required this.phone,
    required this.primary,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        id: json['id'],
        name: json['name'],
        addressLine1: json['addressLine1'],
        addressLine2: json['addressLine2'],
        city: json['city'],
        country: json['country'],
        postalCode: json['postalCode'],
        phone: json['phone'],
        primary: json['primary']
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'addressLine1': addressLine1,
        'addressLine2': addressLine2,
        'city': city,
        'country': country,
        'postalCode': postalCode,
        'phone': phone,
        'primary': primary,
      };
}
