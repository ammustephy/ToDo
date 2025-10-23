class UserProfile {
  final String id;
  final String name;
  final String phone;
  final String? photoUrl;

  UserProfile({
    required this.id,
    required this.name,
    required this.phone,
    this.photoUrl,
  });
}