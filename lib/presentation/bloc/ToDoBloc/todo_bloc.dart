import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/presentation/bloc/ToDoBloc/todo_event.dart';
import 'package:todo/presentation/bloc/ToDoBloc/todo_state.dart';

import '../../../domain/usecases/todo/add_todo_usecase.dart';
import '../../../domain/usecases/todo/delete_todo_usecase.dart';
import '../../../domain/usecases/todo/get_todos_usecase.dart';
import '../../../domain/usecases/todo/update_todo_usecase.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final GetTodosUseCase getTodosUseCase;
  final AddTodoUseCase addTodoUseCase;
  final UpdateTodoUseCase updateTodoUseCase;
  final DeleteTodoUseCase deleteTodoUseCase;

  TodoBloc({
    required this.getTodosUseCase,
    required this.addTodoUseCase,
    required this.updateTodoUseCase,
    required this.deleteTodoUseCase,
  }) : super(TodoInitial()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodo>(_onAddTodo);
    on<ToggleTodo>(_onToggleTodo);
    on<DeleteTodo>(_onDeleteTodo);
  }

  Future<void> _onLoadTodos(LoadTodos event, Emitter<TodoState> emit) async {
    if (state is! TodoLoaded) {
      emit(TodoLoading());
    }

    try {
      final todos = await getTodosUseCase(event.userId);
      emit(TodoLoaded(todos));
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }

  Future<void> _onAddTodo(AddTodo event, Emitter<TodoState> emit) async {
    try {
      await addTodoUseCase(event.todo);
      final todos = await getTodosUseCase(event.todo.userId);
      emit(TodoLoaded(todos));
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }

  Future<void> _onToggleTodo(ToggleTodo event, Emitter<TodoState> emit) async {
    if (state is TodoLoaded) {
      final currentTodos = (state as TodoLoaded).todos;
      final updatedTodos = currentTodos.map((todo) {
        if (todo.id == event.todo.id) {
          return todo.copyWith(isDone: !todo.isDone);
        }
        return todo;
      }).toList();

      emit(TodoLoaded(updatedTodos));
    }

    try {
      final updatedTodo = event.todo.copyWith(isDone: !event.todo.isDone);
      await updateTodoUseCase(updatedTodo);

      final todos = await getTodosUseCase(event.todo.userId);
      emit(TodoLoaded(todos));
    } catch (e) {
      final todos = await getTodosUseCase(event.todo.userId);
      emit(TodoLoaded(todos));
      emit(TodoError(e.toString()));
    }
  }

  Future<void> _onDeleteTodo(DeleteTodo event, Emitter<TodoState> emit) async {
    if (state is TodoLoaded) {
      final currentTodos = (state as TodoLoaded).todos;
      final updatedTodos = currentTodos.where((todo) => todo.id != event.id).toList();
      emit(TodoLoaded(updatedTodos));
    }

    try {
      await deleteTodoUseCase(event.id);
      final todos = await getTodosUseCase(event.userId);
      emit(TodoLoaded(todos));
    } catch (e) {
      final todos = await getTodosUseCase(event.userId);
      emit(TodoLoaded(todos));
      emit(TodoError(e.toString()));
    }
  }
}