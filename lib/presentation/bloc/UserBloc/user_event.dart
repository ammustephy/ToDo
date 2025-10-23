import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateUser extends UserEvent {
  final String name;
  final String phone;
  CreateUser(this.name, this.phone);
  @override
  List<Object?> get props => [name, phone];
}

class UpdateUser extends UserEvent {
  final String id;
  final String name;
  final String phone;
  final String? photoUrl;
  UpdateUser(this.id, this.name, this.phone, this.photoUrl);
  @override
  List<Object?> get props => [id, name, phone, photoUrl];
}

class LoadUser extends UserEvent {
  final String id;
  LoadUser(this.id);
  @override
  List<Object?> get props => [id];
}

class LoginOrRegisterUser extends UserEvent {
  final String name;
  final String phone;
  LoginOrRegisterUser(this.name, this.phone);
  @override
  List<Object?> get props => [name, phone];
}