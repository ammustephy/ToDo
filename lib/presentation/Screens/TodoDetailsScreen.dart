import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/Todo.dart';
import '../bloc/ToDoBloc/todo_bloc.dart';
import '../bloc/ToDoBloc/todo_event.dart';

class TodoDetailScreen extends StatelessWidget {
  final Todo todo;

  const TodoDetailScreen({Key? key, required this.todo}) : super(key: key);

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
    final size = MediaQuery.of(context).size;
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Custom AppBar
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isPortrait ? 20 : size.width * 0.1,
                vertical: 12, // Reduced from 16
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Image.asset(
                      'Assets/Images/leftArrow.png',
                      width: 24,
                      height: 24,
                      color: Colors.black,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                          size: 24,
                        );
                      },
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Text(
                      'Todo Details',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isPortrait ? 20 : 18,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2D3142),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Balance the back button
                ],
              ),
            ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isPortrait ? 20 : size.width * 0.1,
                ),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(isPortrait ? 16 : 14), // Reduced from 20/18
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  todo.title,
                                  style: TextStyle(
                                    fontSize: isPortrait ? 18 : 16,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF2D3142),
                                  ),
                                ),
                              ),
                              Container(
                                width: isPortrait ? 40 : 36,
                                height: isPortrait ? 40 : 36,
                                decoration: BoxDecoration(
                                  color: _getIconColor().withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.task_alt,
                                  color: _getIconColor(),
                                  size: isPortrait ? 22 : 20,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            todo.description.isNotEmpty
                                ? todo.description
                                : 'No description',
                            style: TextStyle(
                              fontSize: isPortrait ? 13 : 12,
                              color: Colors.grey[700],
                              height: 1,
                            ),
                          ),
                          Row(
                            children: [
                              Image.asset("Assets/Images/clock.png",width: 15,height: 15,color: Color(0xFF7C6CF5),),
                              const SizedBox(width: 6),
                              Text(
                                DateFormat('MMM d, hh:mm a').format(todo.createdAt),
                                style: TextStyle(
                                  fontSize: isPortrait ? 12 : 11,
                                  color: const Color(0xFF7C6CF5),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Spacer(),
                              if (!todo.isDone)
                                TextButton(
                                  onPressed: () {
                                    context.read<TodoBloc>().add(ToggleTodo(todo));
                                    Navigator.pop(context);
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: const Color(0xFF7C6CF5).withOpacity(0.1),
                                    foregroundColor: const Color(0xFF7C6CF5),
                                    minimumSize: const Size(50, 30),
                                    shape: StadiumBorder(
                                      side: BorderSide(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    'Done',
                                    style: TextStyle(
                                      fontSize: isPortrait ? 12 : 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              if (todo.isDone)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF7C6CF5).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'Done',
                                    style: TextStyle(
                                      fontSize: isPortrait ? 13 : 12,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF7C6CF5),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}