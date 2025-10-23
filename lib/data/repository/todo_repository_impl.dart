import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/Todo.dart';
import '../../domain/repositories/todo_repository.dart';
import '../models/Todo_model.dart';

class TodoRepositoryImpl implements TodoRepository {
  final SupabaseClient supabaseClient;

  TodoRepositoryImpl(this.supabaseClient);

  @override
  Future<List<Todo>> getTodos(String userId) async {
    try {
      final response = await supabaseClient
          .from('todos')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => TodoModel.fromJson(json).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch todos: $e');
    }
  }

  @override
  Future<Todo> addTodo(Todo todo) async {
    try {
      final todoModel = TodoModel.fromEntity(todo);

      final response = await supabaseClient
          .from('todos')
          .insert(todoModel.toJson())
          .select()
          .single();

      return TodoModel.fromJson(response).toEntity();
    } catch (e) {
      throw Exception('Failed to add todo: $e');
    }
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    try {
      final todoModel = TodoModel.fromEntity(todo);

      await supabaseClient
          .from('todos')
          .update({
        'is_done': todoModel.isDone,
        'title': todoModel.title,
        'description': todoModel.description,
        'start_date': todoModel.startDate.toIso8601String(),
        'end_date': todoModel.endDate.toIso8601String(),
        'icon_color': todoModel.iconColor,
      })
          .eq('id', todo.id);
    } catch (e) {
      throw Exception('Failed to update todo: $e');
    }
  }

  @override
  Future<void> deleteTodo(String id) async {
    try {
      await supabaseClient.from('todos').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete todo: $e');
    }
  }
}