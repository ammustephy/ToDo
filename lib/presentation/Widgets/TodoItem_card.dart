import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/Todo.dart';
import '../Screens/TodoDetailsScreen.dart';
import '../bloc/ToDoBloc/todo_bloc.dart';
import '../bloc/ToDoBloc/todo_event.dart';

class TodoItemCard extends StatelessWidget {
  final Todo todo;
  final bool isPortrait;
  final String userId;

  const TodoItemCard({
    Key? key,
    required this.todo,
    required this.isPortrait,
    required this.userId,
  }) : super(key: key);

  Color _getIconColor() {
    if (todo.iconColor != null) {
      switch (todo.iconColor) {
        case 'red':
          return const Color(0xFFE74C3C);
        case 'orange':
          return const Color(0xFFFF9F43);
        case 'yellow':
          return const Color(0xFFFFC107);
        case 'green':
          return const Color(0xFF27AE60);
        default:
          return const Color(0xFF7C6CF5);
      }
    }
    return const Color(0xFF7C6CF5);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: isPortrait ? 12 : 10),
      child: Dismissible(
        key: ValueKey(todo.id),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) async {
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Delete Task'),
                content: const Text('Are you sure you want to delete this task?'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                    child: const Text('Delete'),
                  ),
                ],
              );
            },
          );
        },
        onDismissed: (direction) {
          context.read<TodoBloc>().add(DeleteTodo(todo.id, userId));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Task deleted'),
              duration: const Duration(seconds: 2),
              backgroundColor: Colors.red,
            ),
          );
        },
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.05),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TodoDetailScreen(todo: todo),
                ),
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: EdgeInsets.all(isPortrait ? 16 : 14),
              child: Row(
                children: [
                  Container(
                    width: isPortrait ? 48 : 40,
                    height: isPortrait ? 48 : 40,
                    decoration: BoxDecoration(
                      color: _getIconColor().withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.task_alt,
                      color: _getIconColor(),
                      size: isPortrait ? 24 : 20,
                    ),
                  ),
                  SizedBox(width: isPortrait ? 16 : 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          todo.title,
                          style: TextStyle(
                            fontSize: isPortrait ? 16 : 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF2D3142),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (todo.description.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            todo.description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: isPortrait ? 12 : 11,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (todo.isDone)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Done',
                        style: TextStyle(
                          fontSize: isPortrait ? 12 : 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF4CAF50),
                        ),
                      ),
                    ),
                  const SizedBox(width: 8),
                  // Delete button
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.black),
                    iconSize: isPortrait ? 24 : 20,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Delete Task'),
                            content: const Text('Are you sure you want to delete this task?'),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.red,
                                ),
                                child: const Text('Delete'),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirmed == true) {
                        context.read<TodoBloc>().add(DeleteTodo(todo.id, userId));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Task deleted'),
                            duration: Duration(seconds: 2),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}