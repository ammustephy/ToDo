import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/presentation/bloc/UserBloc/user_event.dart';
import 'package:todo/presentation/bloc/UserBloc/user_state.dart';

import '../../../domain/usecases/user/create_user_usecase.dart';
import '../../../domain/usecases/user/get_user_by_phone_usecase.dart';
import '../../../domain/usecases/user/get_user_usecase.dart';
import '../../../domain/usecases/user/update_user_usecase.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final CreateUserUseCase createUserUseCase;
  final UpdateUserUseCase updateUserUseCase;
  final GetUserUseCase getUserUseCase;
  final GetUserByPhoneUseCase getUserByPhoneUseCase;

  UserBloc({
    required this.createUserUseCase,
    required this.updateUserUseCase,
    required this.getUserUseCase,
    required this.getUserByPhoneUseCase,
  }) : super(UserInitial()) {
    on<CreateUser>(_onCreateUser);
    on<UpdateUser>(_onUpdateUser);
    on<LoadUser>(_onLoadUser);
    on<LoginOrRegisterUser>(_onLoginOrRegisterUser);
  }

  Future<void> _onCreateUser(CreateUser event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final user = await createUserUseCase(event.name, event.phone);
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onUpdateUser(UpdateUser event, Emitter<UserState> emit) async {
    final previousState = state;
    if (previousState is! UserLoaded) {
      emit(UserLoading());
    }

    try {
      final user = await updateUserUseCase(event.id, event.name, event.phone, event.photoUrl);
      emit(UserLoaded(user));
    } catch (e) {
      if (previousState is UserLoaded) {
        emit(previousState);
      }
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onLoadUser(LoadUser event, Emitter<UserState> emit) async {
    if (state is! UserLoaded) {
      emit(UserLoading());
    }

    try {
      final user = await getUserUseCase(event.id);
      if (user != null) {
        emit(UserLoaded(user));
      } else {
        emit(UserError('User not found'));
      }
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onLoginOrRegisterUser(
      LoginOrRegisterUser event,
      Emitter<UserState> emit,
      ) async {
    emit(UserLoading());
    try {
      final existingUser = await getUserByPhoneUseCase(event.phone);

      if (existingUser != null) {
        emit(UserLoaded(existingUser));
      } else {
        final newUser = await createUserUseCase(event.name, event.phone);
        emit(UserLoaded(newUser));
      }
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}