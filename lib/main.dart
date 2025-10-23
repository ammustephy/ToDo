import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo/presentation/Screens/SplashScreen.dart';
import 'package:todo/presentation/bloc/ToDoBloc/todo_bloc.dart';
import 'package:todo/presentation/bloc/UserBloc/user_bloc.dart';
import 'Core/Subabase_config.dart';
import 'data/repository/todo_repository_impl.dart';
import 'data/repository/user_repository_impl.dart';
import 'domain/usecases/todo/add_todo_usecase.dart';
import 'domain/usecases/todo/delete_todo_usecase.dart';
import 'domain/usecases/todo/get_todos_usecase.dart';
import 'domain/usecases/todo/update_todo_usecase.dart';
import 'domain/usecases/user/create_user_usecase.dart';
import 'domain/usecases/user/get_user_by_phone_usecase.dart';
import 'domain/usecases/user/get_user_usecase.dart';
import 'domain/usecases/user/update_user_usecase.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

   await initSupabase();

  runApp(const MyApp());
}

Future<void> initSupabase() async {
  try {
     await Supabase.initialize(
      url: SupabaseConfig.supabaseUrl,
      anonKey: SupabaseConfig.supabaseAnonKey,
    );
    print('Supabase initialized successfully');
  } catch (e) {
    print('Supabase initialization error: $e');
    print('URL: ${SupabaseConfig.supabaseUrl}');
    print('Make sure internet permissions are set in AndroidManifest.xml');
    rethrow;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final supabaseClient = Supabase.instance.client;

    final todoRepository = TodoRepositoryImpl(supabaseClient);
    final userRepository = UserRepositoryImpl(supabaseClient);

    final getTodosUseCase = GetTodosUseCase(todoRepository);
    final addTodoUseCase = AddTodoUseCase(todoRepository);
    final updateTodoUseCase = UpdateTodoUseCase(todoRepository);
    final deleteTodoUseCase = DeleteTodoUseCase(todoRepository);

    final createUserUseCase = CreateUserUseCase(userRepository);
    final updateUserUseCase = UpdateUserUseCase(userRepository);
    final getUserUseCase = GetUserUseCase(userRepository);
    final getUserByPhoneUseCase = GetUserByPhoneUseCase(userRepository);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TodoBloc(
            getTodosUseCase: getTodosUseCase,
            addTodoUseCase: addTodoUseCase,
            updateTodoUseCase: updateTodoUseCase,
            deleteTodoUseCase: deleteTodoUseCase,
          ),
        ),
        BlocProvider(
          create: (context) => UserBloc(
            createUserUseCase: createUserUseCase,
            updateUserUseCase: updateUserUseCase,
            getUserUseCase: getUserUseCase,
            getUserByPhoneUseCase: getUserByPhoneUseCase,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Task Management',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFF7C6CF5),
          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'Poppins',
        ),
        home: const SplashScreen(),
      ),
    );
  }
}