import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class LeaveScheduleEvent extends Equatable{
  const LeaveScheduleEvent();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LeaveScheduleEventRequested extends LeaveScheduleEvent{
  final String dentistId;
  final String startDate;
  final String endDate;
  final String shiftWork;
  final String reason;

  const LeaveScheduleEventRequested({@required this.dentistId, this.startDate, this.endDate, this.shiftWork, this.reason});
  @override
  // TODO: implement props
  List<Object> get props => [dentistId];
}