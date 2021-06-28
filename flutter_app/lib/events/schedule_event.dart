import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class ScheduleEvent extends Equatable{
  const ScheduleEvent();
}

class ScheduleEventRequested extends ScheduleEvent{
  final String dentistId;
  final String appointmentDate;
  final String workShift;
  const ScheduleEventRequested({@required this.workShift, this.dentistId, this.appointmentDate}) : assert(dentistId != null, appointmentDate != null);

  @override
  // TODO: implement props
  List<Object> get props => [dentistId];
}
class ScheduleAddEventRequested extends ScheduleEvent{
  final String patientId;
  final String patientName;
  final String dentistId;
  final String appointmentDate;
  final String note;
  final int blockId;

  const ScheduleAddEventRequested({@required this.patientId, this.patientName, this.dentistId, this.appointmentDate, this.note, this.blockId});

  @override
  // TODO: implement props
  List<Object> get props => [patientId];
}

class ScheduleDelEventRequested extends ScheduleEvent{
  final String bookedId;
  final String reason;
  // ignore: non_constant_identifier_names
  const ScheduleDelEventRequested({@required this.bookedId, this.reason});

  @override
  // TODO: implement props
  List<Object> get props => [bookedId];
}