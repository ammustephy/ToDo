import '../../entities/User_profile.dart';
import '../../repositories/user_repository.dart';

class GetUserUseCase {
  final UserRepository repository;

  GetUserUseCase(this.repository);

  Future<UserProfile?> call(String id) async {
    return await repository.getUser(id);
  }
}