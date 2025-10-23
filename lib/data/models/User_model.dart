import '../../domain/entities/User_profile.dart';

class UserModel {
  final String id;
  final String name;
  final String phone;
  final String? photoUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    this.photoUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      photoUrl: json['photo_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'photo_url': photoUrl,
    };
  }

  UserProfile toEntity() {
    return UserProfile(
      id: id,
      name: name,
      phone: phone,
      photoUrl: photoUrl,
    );
  }
}