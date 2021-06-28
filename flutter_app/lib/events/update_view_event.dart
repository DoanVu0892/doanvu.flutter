import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class UpdateViewEvent extends Equatable{
  const UpdateViewEvent();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class UpdateViewChangedEvent extends UpdateViewEvent{
  final String title;
  const UpdateViewChangedEvent({@required this.title}) : assert(title != null);
  @override
  // TODO: implement props
  List<Object> get props => [title];
}