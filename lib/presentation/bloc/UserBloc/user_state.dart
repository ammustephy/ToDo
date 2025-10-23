import 'package:equatable/equatable.dart';

import '../../../domain/entities/User_profile.dart';

abstract class UserState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final UserProfile user;
  UserLoaded(this.user);
  @override
  List<Object?> get props => [user.id, user.name, user.phone, user.photoUrl];
}

class UserError extends UserState {
  final String message;
  UserError(this.message);
  @override
  List<Object?> get props => [message];
}