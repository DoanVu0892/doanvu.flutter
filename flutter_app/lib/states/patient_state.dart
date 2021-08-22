import 'package:equatable/equatable.dart';
import 'package:flutter_app/models/patient.dart';

abstract class PatientState extends Equatable {
  const PatientState();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class PatientStateInitial extends PatientState {}

class PatientStateLoading extends PatientState {}

class PatientStateSuccess extends PatientState {
  final PatientResponse response;
  const PatientStateSuccess({this.response});
  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class PatientStateFailure extends PatientState {
  final PatientResponse response;
  const PatientStateFailure({this.response});
  @override
  // TODO: implement props
  List<Object> get props => [response];
}
