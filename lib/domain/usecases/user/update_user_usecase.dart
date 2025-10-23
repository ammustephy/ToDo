import '../../entities/User_profile.dart';
import '../../repositories/user_repository.dart';

class UpdateUserUseCase {
  final UserRepository repository;

  UpdateUserUseCase(this.repository);

  Future<UserProfile> call(String id, String name, String phone, String? photoUrl) async {
    return await repository.updateUser(id, name, phone, photoUrl);
  }
}