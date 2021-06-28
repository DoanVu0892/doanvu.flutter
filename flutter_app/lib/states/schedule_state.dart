import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/models/schedule.dart';
import 'package:flutter_app/models/schedule_add.dart';

abstract class ScheduleState extends Equatable{
  const ScheduleState();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ScheduleStateInitial extends ScheduleState{}
class ScheduleStateLoading extends ScheduleState{}
class ScheduleStateSuccess extends ScheduleState{
  final ScheduleResponse response;
  const ScheduleStateSuccess({@required this.response});
  @override
  // TODO: implement props
  List<Object> get props => [response];
}
class ScheduleStateFailure extends ScheduleState{}

class ScheduleAddStateLoading extends ScheduleState{}
class ScheduleAddStateSuccess extends ScheduleState{
  final ScheduleAddResponse response;
  const ScheduleAddStateSuccess({@required this.response});
  @override
  // TODO: implement props
  List<Object> get props => [response];
}
class ScheduleAddStateFailure extends ScheduleState{}

class ScheduleDelStateLoading extends ScheduleState{}
class ScheduleDelStateSuccess extends ScheduleState{
  final ScheduleDelResponse response;
  const ScheduleDelStateSuccess({@required this.response});
  @override
  // TODO: implement props
  List<Object> get props => [response];
}
class ScheduleDelStateFailure extends ScheduleState{}