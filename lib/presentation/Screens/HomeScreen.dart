import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/Todo.dart';
import '../Widgets/TodoItem_card.dart';
import '../bloc/ToDoBloc/todo_bloc.dart';
import '../bloc/ToDoBloc/todo_event.dart';
import '../bloc/ToDoBloc/todo_state.dart';
import '../bloc/UserBloc/user_bloc.dart';
import '../bloc/UserBloc/user_event.dart';
import '../bloc/UserBloc/user_state.dart';
import 'AddTaskScreen.dart';
import 'ProfileScreen.dart';



class HomeScreen extends StatefulWidget {
  final String userId;

  const HomeScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load data only once during initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<UserBloc>().add(LoadUser(widget.userId));
        context.read<TodoBloc>().add(LoadTodos(widget.userId));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 70,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0, top: 5.0, bottom: 5.0),
          child: BlocBuilder<UserBloc, UserState>(
            // CRITICAL FIX: Only rebuild when transitioning from non-loaded to loaded
            buildWhen: (previous, current) {
              // Never rebuild if already showing loaded data
              if (previous is UserLoaded && current is UserLoaded) {
                return false; // Don't rebuild for subsequent UserLoaded states
              }
              // Only rebuild when first loading completes
              return current is UserLoaded;
            },
            builder: (context, state) {
              if (state is! UserLoaded) {
                // Static placeholder - no animation
                return Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                );
              }
              return CircleAvatar(
                radius: 26,
                backgroundColor: const Color(0xFF7C6CF5),
                backgroundImage: state.user.photoUrl != null && state.user.photoUrl!.isNotEmpty
                    ? NetworkImage(state.user.photoUrl!)
                    : null,
                child: state.user.photoUrl == null || state.user.photoUrl!.isEmpty
                    ? const Icon(Icons.person, color: Colors.white, size: 28)
                    : null,
              );
            },
          ),
        ),
        titleSpacing: 8,
        title: BlocBuilder<UserBloc, UserState>(
          // CRITICAL FIX: Same strict condition
          buildWhen: (previous, current) {
            if (previous is UserLoaded && current is UserLoaded) {
              return false;
            }
            return current is UserLoaded;
          },
          builder: (context, state) {
            if (state is! UserLoaded) {
              // Static placeholder
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 80,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello!',
                  style: TextStyle(
                    fontSize: isPortrait ? 14 : 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Text(
                  state.user.name,
                  style: TextStyle(
                    fontSize: isPortrait ? 18 : 16,
                    color: const Color(0xFF2D3142),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            );
          },
        ),
        actions: [
          IconButton(
            icon: Image.asset(
              "Assets/Images/notification.png",
              color: Colors.black,
              height: 22,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.notifications, color: Colors.black, size: 22);
              },
            ),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onSelected: (value) {
              if (value == 'profile') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileSettingsScreen(userId: widget.userId),
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'profile',
                child: Text('Profile Settings'),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isPortrait ? 20 : size.width * 0.1,
            vertical: isPortrait ? 20 : 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with count
              BlocBuilder<TodoBloc, TodoState>(
                // CRITICAL FIX: Prevent rebuilds when data hasn't changed
                buildWhen: (previous, current) {
                  // Don't rebuild if both are loaded with same data
                  if (previous is TodoLoaded && current is TodoLoaded) {
                    return previous.todos.length != current.todos.length;
                  }
                  // Don't rebuild on loading if we have data
                  if (previous is TodoLoaded && current is TodoLoading) {
                    return false;
                  }
                  return current is TodoLoaded || current is TodoError;
                },
                builder: (context, state) {
                  int count = 0;
                  if (state is TodoLoaded) {
                    count = state.todos.length;
                  }

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Task To do',
                        style: TextStyle(
                          fontSize: isPortrait ? 24 : 20,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2D3142),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF7C6CF5).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$count',
                          style: TextStyle(
                            fontSize: isPortrait ? 13 : 12,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF7C6CF5),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: isPortrait ? 20 : 16),
              // Main content
              Expanded(
                child: BlocConsumer<TodoBloc, TodoState>(
                  // CRITICAL FIX: Strict rebuild conditions
                  buildWhen: (previous, current) {
                    // Don't rebuild on loading if we already have data
                    if (previous is TodoLoaded && current is TodoLoading) {
                      return false;
                    }
                    // Don't rebuild if data is identical
                    if (previous is TodoLoaded && current is TodoLoaded) {
                      if (previous.todos.length == current.todos.length) {
                        // Check if todos are actually different
                        bool hasChanges = false;
                        for (int i = 0; i < previous.todos.length; i++) {
                          if (previous.todos[i].id != current.todos[i].id ||
                              previous.todos[i].isDone != current.todos[i].isDone) {
                            hasChanges = true;
                            break;
                          }
                        }
                        return hasChanges;
                      }
                    }
                    return true;
                  },
                  listener: (context, state) {
                    if (state is TodoError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: ${state.message}'),
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  builder: (context, todoState) {
                    // Show loading only on initial load
                    if (todoState is TodoLoading || todoState is TodoInitial) {
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7C6CF5)),
                        ),
                      );
                    }

                    if (todoState is TodoError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error, size: 64, color: Colors.red),
                            const SizedBox(height: 16),
                            const Text(
                              'Error loading tasks',
                              style: TextStyle(color: Colors.red, fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => context.read<TodoBloc>().add(LoadTodos(widget.userId)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF7C6CF5),
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    if (todoState is TodoLoaded) {
                      if (todoState.todos.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.task_alt,
                                size: isPortrait ? 80 : 60,
                                color: Colors.grey[300],
                              ),
                              SizedBox(height: isPortrait ? 16 : 12),
                              Text(
                                'No tasks yet!',
                                style: TextStyle(
                                  fontSize: isPortrait ? 20 : 18,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: isPortrait ? 8 : 6),
                              Text(
                                'Tap + to add a new task',
                                style: TextStyle(
                                  fontSize: isPortrait ? 14 : 12,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        // Add key to prevent rebuilds
                        key: ValueKey('todo_list_${todoState.todos.length}'),
                        physics: const BouncingScrollPhysics(),
                        itemCount: todoState.todos.length,
                        itemBuilder: (context, index) {
                          final todo = todoState.todos[index];
                          return TodoItemCard(
                            key: ValueKey(todo.id), // Prevent item rebuilds
                            todo: todo,
                            isPortrait: isPortrait,
                            userId: widget.userId,
                          );
                        },
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_todo', // Prevent hero animation issues
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTaskScreen(userId: widget.userId),
            ),
          );
        },
        backgroundColor: const Color(0xFF7C6CF5),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 32, color: Colors.white),
      ),
    );
  }
}


