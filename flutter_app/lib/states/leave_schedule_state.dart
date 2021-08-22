import 'package:equatable/equatable.dart';
import 'package:flutter_app/models/leave_schedule.dart';

abstract class LeaveScheduleState extends Equatable {
  const LeaveScheduleState();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LeaveScheduleInitial extends LeaveScheduleState {}

class LeaveScheduleLoading extends LeaveScheduleState {}

class LeaveScheduleSuccess extends LeaveScheduleState {
  final ResLeaveSchedule response;
  const LeaveScheduleSuccess({this.response});
}

class LeaveScheduleFailure extends LeaveScheduleState {
  final ResLeaveSchedule response;
  const LeaveScheduleFailure({this.response});
}
