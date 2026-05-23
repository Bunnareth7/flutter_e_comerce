class Address {
  final String id;
  final String fullName;
  final String phone;
  final String street;
  final String city;
  final String state;
  final String zip;
  final bool isDefault;

  Address({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.street,
    required this.city,
    required this.state,
    required this.zip,
    this.isDefault = false,
  });
}