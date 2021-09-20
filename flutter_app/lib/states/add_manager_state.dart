import 'package:equatable/equatable.dart';

abstract class UserManagerState extends Equatable {
  const UserManagerState();
  @override
  List<Object> get props => [];
}

class UserManagerStateInitial extends UserManagerState {}

class UserManagerStateLoading extends UserManagerState {}

class UserManagerStateSuccess extends UserManagerState {}

class UserManagerStateFailure extends UserManagerState {}

class UserManagerStateLogout extends UserManagerState {}
