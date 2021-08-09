import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class UserManagerEvent extends Equatable{
  const UserManagerEvent();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class UserManagerEventRequested extends UserManagerEvent{
  final String phone;
  final String password;
  final String name;
  final int clinicId;

  const UserManagerEventRequested({@required this.phone, this.clinicId, this.password, this.name});

  @override
  // TODO: implement props
  List<Object> get props => [phone];
}