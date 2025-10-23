import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/Todo.dart';
import '../bloc/ToDoBloc/todo_bloc.dart';
import '../bloc/ToDoBloc/todo_event.dart';
import '../bloc/ToDoBloc/todo_state.dart';

class AddTaskScreen extends StatefulWidget {
  final String userId;

  const AddTaskScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  String _selectedColor = 'purple';

  final List<Map<String, dynamic>> _colors = [
    {'name': 'red', 'color': const Color(0xFFE74C3C)},
    {'name': 'orange', 'color': const Color(0xFFFF9F43)},
    {'name': 'yellow', 'color': const Color(0xFFFFC107)},
    {'name': 'green', 'color': const Color(0xFF27AE60)},
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Image.asset(
            'Assets/Images/leftArrow.png',
            width: 24,
            height: 24,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Add task',
          style: TextStyle(
            fontSize: isPortrait ? 20 : 18,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF2D3142),
          ),
        ),
        actions: [
          IconButton(
            icon: Image.asset("Assets/Images/notification.png", color: Colors.black, height: 22,),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocListener<TodoBloc, TodoState>(
        listener: (context, state) {
          if (state is TodoLoaded) {
            Navigator.pop(context);
          } else if (state is TodoError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isPortrait ? 24 : size.width * 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Project Name',
                  hintText: 'Office Project',
                  labelStyle: TextStyle(color: Colors.grey, fontSize: 15),
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF7C6CF5)),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: isPortrait ? 20 : 16),
              TextField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Has to do some optimization',
                  labelStyle: TextStyle(color: Colors.grey, fontSize: 15),
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                  floatingLabelAlignment: FloatingLabelAlignment.start,
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF7C6CF5)),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: isPortrait ? 20 : 16),
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _startDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: Color(0xFF7C6CF5),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (date != null) {
                    setState(() {
                      _startDate = date;
                    });
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(isPortrait ? 16 : 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('dd MMMM, yyyy').format(_startDate),
                        style: TextStyle(
                          fontSize: isPortrait ? 14 : 14,
                          color: Colors.grey,
                        ),
                      ),
                      Image.asset(
                        'Assets/Images/downArrow.png',
                        width: 20,
                        height: 20,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: isPortrait ? 20 : 16),
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _endDate,
                    firstDate: _startDate,
                    lastDate: DateTime(2100),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: Color(0xFF7C6CF5),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (date != null) {
                    setState(() {
                      _endDate = date;
                    });
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(isPortrait ? 14 : 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('dd MMMM, yyyy').format(_endDate),
                        style: TextStyle(
                          fontSize: isPortrait ? 15 : 14,
                          color: Colors.grey,
                        ),
                      ),
                      Image.asset(
                        'Assets/Images/downArrow.png',
                        width: 20,
                        height: 20,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: isPortrait ? 20 : 16),
              Row(
                children: _colors.map((colorData) {
                  final isSelected = _selectedColor == colorData['name'];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedColor = colorData['name'];
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      width: isPortrait ? 40 : 36,
                      height: isPortrait ? 40 : 36,
                      decoration: BoxDecoration(
                        color: colorData['color'],
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: Color(0xFF7C6CF5), width: 2)
                            : null,
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: isPortrait ? 40 : 30),
              SizedBox(
                width: double.infinity,
                height: isPortrait ? 56 : 48,
                child: ElevatedButton(
                  onPressed: () {
                    if (_titleController.text.isNotEmpty) {
                      final todo = Todo(
                        id: '',
                        userId: widget.userId,
                        title: _titleController.text,
                        description: _descriptionController.text,
                        startDate: _startDate,
                        endDate: _endDate,
                        isDone: false,
                        iconColor: _selectedColor,
                        createdAt: DateTime.now(),
                      );
                      context.read<TodoBloc>().add(AddTodo(todo));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C6CF5),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Add Project',
                    style: TextStyle(
                      fontSize: isPortrait ? 18 : 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}