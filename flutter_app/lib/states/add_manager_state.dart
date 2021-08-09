import 'package:equatable/equatable.dart';

abstract class UserManagerState extends Equatable{
  const UserManagerState();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class UserManagerStateInitial extends UserManagerState{}
class UserManagerStateLoading extends UserManagerState{}
class UserManagerStateSuccess extends UserManagerState{}
class UserManagerStateFailure extends UserManagerState{}