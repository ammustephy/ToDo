import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/User_profile.dart';
import '../../domain/repositories/user_repository.dart';
import '../models/User_model.dart';

class UserRepositoryImpl implements UserRepository {
  final SupabaseClient supabaseClient;

  UserRepositoryImpl(this.supabaseClient);

  @override
  Future<UserProfile> createUser(String name, String phone) async {
    try {
      final response = await supabaseClient
          .from('users')
          .insert({'name': name, 'phone': phone})
          .select()
          .single();

      return UserModel.fromJson(response).toEntity();
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  @override
  Future<UserProfile> updateUser(String id, String name, String phone,
      String? photoUrl) async {
    try {
      final response = await supabaseClient
          .from('users')
          .update({
        'name': name,
        'phone': phone,
        'photo_url': photoUrl,
      })
          .eq('id', id)
          .select()
          .single();

      return UserModel.fromJson(response).toEntity();
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  @override
  Future<UserProfile?> getUser(String id) async {
    try {
      final response = await supabaseClient
          .from('users')
          .select()
          .eq('id', id)
          .single();

      return UserModel.fromJson(response).toEntity();
    } catch (e) {
      return null;
    }
  }


  @override
  Future<UserProfile?> getUserByPhone(String phone) async {
    try {
      final response = await supabaseClient
          .from('users')
          .select()
          .eq('phone', phone)
          .maybeSingle();

      if (response == null) {
        return null;
      }

      return UserModel.fromJson(response).toEntity();
    } catch (e) {
      print('Error fetching user by phone: $e');
      return null;
    }
  }
}