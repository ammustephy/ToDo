import '../entities/User_profile.dart';

abstract class UserRepository {
  Future<UserProfile> createUser(String name, String phone);
  Future<UserProfile> updateUser(String id, String name, String phone, String? photoUrl);
  Future<UserProfile?> getUser(String id);
  Future<UserProfile?> getUserByPhone(String phone);
}