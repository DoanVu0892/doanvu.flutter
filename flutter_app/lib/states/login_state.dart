import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app/models/user.dart';

abstract class LoginState extends Equatable{
  const LoginState();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoginStateInitial extends LoginState{}
class LoginStateLoading extends LoginState{}
class LoginStateSuccess extends LoginState{
  final Response response;
  const LoginStateSuccess({@required this.response}) : assert(response != null);
  @override
  // TODO: implement props
  List<Object> get props => [response];
}
class LoginStateFailure extends LoginState{}