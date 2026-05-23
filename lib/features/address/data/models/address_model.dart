import '../../domain/entities/address.dart';

class AddressModel extends Address {
  AddressModel({
    required String id,
    required String fullName,
    required String phone,
    required String street,
    required String city,
    required String state,
    required String zip,
    bool isDefault = false,
  }) : super(
          id: id,
          fullName: fullName,
          phone: phone,
          street: street,
          city: city,
          state: state,
          zip: zip,
          isDefault: isDefault,
        );

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'],
      fullName: json['fullName'],
      phone: json['phone'],
      street: json['street'],
      city: json['city'],
      state: json['state'] ?? '',
      zip: json['zip'],
      isDefault: json['isDefault'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'phone': phone,
      'street': street,
      'city': city,
      'state': state,
      'zip': zip,
      'isDefault': isDefault ? 1 : 0,
    };
  }
}