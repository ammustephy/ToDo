import '../../../data/repository/todo_repository_impl.dart';
import '../../entities/Todo.dart';
import '../../repositories/todo_repository.dart';

class GetTodosUseCase {
  final TodoRepository repository;

  GetTodosUseCase(this.repository);

  Future<List<Todo>> call(String userId) async {
    return await repository.getTodos(userId);
  }
}