import '../../domain/entities/Todo.dart';

class TodoModel {
  final String id;
  final String userId;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final bool isDone;
  final String? iconColor;
  final DateTime createdAt;

  TodoModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.isDone,
    this.iconColor,
    required this.createdAt,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      description: json['description'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      isDone: json['is_done'] ?? false,
      iconColor: json['icon_color'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'title': title,
      'description': description,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'is_done': isDone,
      'icon_color': iconColor,
    };
  }

  Todo toEntity() {
    return Todo(
      id: id,
      userId: userId,
      title: title,
      description: description,
      startDate: startDate,
      endDate: endDate,
      isDone: isDone,
      iconColor: iconColor,
      createdAt: createdAt,
    );
  }

  factory TodoModel.fromEntity(Todo todo) {
    return TodoModel(
      id: todo.id,
      userId: todo.userId,
      title: todo.title,
      description: todo.description,
      startDate: todo.startDate,
      endDate: todo.endDate,
      isDone: todo.isDone,
      iconColor: todo.iconColor,
      createdAt: todo.createdAt,
    );
  }
}