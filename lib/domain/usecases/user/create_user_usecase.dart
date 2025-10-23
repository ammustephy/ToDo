import '../../entities/User_profile.dart';
import '../../repositories/user_repository.dart';

class CreateUserUseCase {
  final UserRepository repository;

  CreateUserUseCase(this.repository);

  Future<UserProfile> call(String name, String phone) async {
    return await repository.createUser(name, phone);
  }
}