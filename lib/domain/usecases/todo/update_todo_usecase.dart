import '../../entities/Todo.dart';
import '../../repositories/todo_repository.dart';

class UpdateTodoUseCase {
  final TodoRepository repository;

  UpdateTodoUseCase(this.repository);

  Future<void> call(Todo todo) async {
    return await repository.updateTodo(todo);
  }
}