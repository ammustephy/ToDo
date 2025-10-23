import '../../entities/Todo.dart';
import '../../repositories/todo_repository.dart';

class AddTodoUseCase {
  final TodoRepository repository;

  AddTodoUseCase(this.repository);

  Future<Todo> call(Todo todo) async {
    return await repository.addTodo(todo);
  }
}