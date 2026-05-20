class UserProfile {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final String? address;
  final String? avatarUrl;

  UserProfile({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    this.address,
    this.avatarUrl,
  });
}