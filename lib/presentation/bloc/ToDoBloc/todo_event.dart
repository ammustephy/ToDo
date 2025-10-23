import '../../../domain/entities/Todo.dart';
import 'package:equatable/equatable.dart';

abstract class TodoEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTodos extends TodoEvent {
  final String userId;
  LoadTodos(this.userId);
  @override
  List<Object?> get props => [userId];
}

class AddTodo extends TodoEvent {
  final Todo todo;
  AddTodo(this.todo);
  @override
  List<Object?> get props => [todo];
}

class ToggleTodo extends TodoEvent {
  final Todo todo;
  ToggleTodo(this.todo);
  @override
  List<Object?> get props => [todo];
}

class DeleteTodo extends TodoEvent {
  final String id;
  final String userId;
  DeleteTodo(this.id, this.userId);
  @override
  List<Object?> get props => [id, userId];
}