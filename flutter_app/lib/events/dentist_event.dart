import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class DentistEvent extends Equatable {
  const DentistEvent();
}

class DentistEventRequested extends DentistEvent {
  const DentistEventRequested();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class DentistAddEventRequested extends DentistEvent {
  final int clinicId;
  final String name;
  final String phone;
  const DentistAddEventRequested(
      {@required this.clinicId, this.name, this.phone})
      : assert(clinicId != null);
  @override
  // TODO: implement props
  List<Object> get props => [clinicId];
}

class DentistEditEventRequested extends DentistEvent {
  final int dentistId;
  final String name;
  final String phone;
  const DentistEditEventRequested(
      {@required this.dentistId, this.name, this.phone})
      : assert(dentistId != null);
  @override
  // TODO: implement props
  List<Object> get props => [dentistId];
}

class DentistDelEventRequested extends DentistEvent {
  final int dentistId;
  const DentistDelEventRequested({@required this.dentistId})
      : assert(dentistId != null);
  @override
  // TODO: implement props
  List<Object> get props => [dentistId];
}
