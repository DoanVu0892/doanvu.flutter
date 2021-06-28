import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class DentistEvent extends Equatable{
  const DentistEvent();
}

class DentistEventRequested extends DentistEvent{
  final String clinicId;
  const DentistEventRequested({@required this.clinicId}) : assert(clinicId != null);
  @override
  // TODO: implement props
  List<Object> get props => [clinicId];
}
class DentistAddEventRequested extends DentistEvent{
  final String clinicId;
  final String name;
  final String phone;
  const DentistAddEventRequested({@required this.clinicId, this.name, this.phone}) : assert(clinicId != null);
  @override
  // TODO: implement props
  List<Object> get props => [clinicId];
}
class DentistEditEventRequested extends DentistEvent{
  final String dentistId;
  final String name;
  final String phone;
  const DentistEditEventRequested({@required this.dentistId, this.name, this.phone}) : assert(dentistId != null);
  @override
  // TODO: implement props
  List<Object> get props => [dentistId];
}
class DentistDelEventRequested extends DentistEvent{
  final String dentistId;
  const DentistDelEventRequested({@required this.dentistId}) : assert(dentistId != null);
  @override
  // TODO: implement props
  List<Object> get props => [dentistId];
}