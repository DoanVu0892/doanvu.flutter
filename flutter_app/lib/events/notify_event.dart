import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class NotifyEvent extends Equatable{
  const NotifyEvent();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class NotifyManagerEventRequested extends NotifyEvent{}
class NotifyEventRequested extends NotifyEvent{
  final int patientId;
  const NotifyEventRequested({@required this.patientId}) : assert(patientId != null);
  @override
  // TODO: implement props
  List<Object> get props => [patientId];
}