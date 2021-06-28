import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class UpdateViewState extends Equatable{
  const UpdateViewState();
}

class UpdateViewStateChanged extends UpdateViewState{
  final String title;
  const UpdateViewStateChanged({@required this.title}) : assert(title != null);
  @override
  // TODO: implement props
  List<Object> get props => [title];
}