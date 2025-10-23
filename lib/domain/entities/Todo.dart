class Todo {
  final String id;
  final String userId;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final bool isDone;
  final String? iconColor;
  final DateTime createdAt;

  Todo({
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

  Todo copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    bool? isDone,
    String? iconColor,
    DateTime? createdAt,
  }) {
    return Todo(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isDone: isDone ?? this.isDone,
      iconColor: iconColor ?? this.iconColor,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}