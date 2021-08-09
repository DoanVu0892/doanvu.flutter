import 'package:equatable/equatable.dart';

abstract class PatientEvent extends Equatable{
  const PatientEvent();
}

class PatientEventRequested extends PatientEvent{
  final int dentistId;
  PatientEventRequested({this.dentistId}) : assert (dentistId != null);
  @override
  // TODO: implement props
  List<Object> get props => [dentistId];
}

class PatientEventSearch extends PatientEvent{
  final String dentistId;
  final String keyWord;
  PatientEventSearch({this.dentistId, this.keyWord}) : assert (dentistId != null);

  @override
  // TODO: implement props
  List<Object> get props => [dentistId];
}

