import '../../entities/User_profile.dart';
import '../../repositories/user_repository.dart';

class GetUserByPhoneUseCase {
  final UserRepository repository;

  GetUserByPhoneUseCase(this.repository);

  Future<UserProfile?> call(String phone) async {
    return await repository.getUserByPhone(phone);
  }
}