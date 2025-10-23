import '../entities/Todo.dart';

abstract class TodoRepository {
  Future<List<Todo>> getTodos(String userId);
  Future<Todo> addTodo(Todo todo);
  Future<void> updateTodo(Todo todo);
  Future<void> deleteTodo(String id);
}