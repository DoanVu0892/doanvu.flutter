import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class LoginEvent extends Equatable{
  const LoginEvent();
}
class LoginEventRequested extends LoginEvent{
  final String phoneNumber;
  final String pwd;
  const LoginEventRequested({@required this.phoneNumber, this.pwd}) : assert(phoneNumber != null, pwd != null);
  @override
  // TODO: implement props
  List<Object> get props => [phoneNumber, pwd];
}