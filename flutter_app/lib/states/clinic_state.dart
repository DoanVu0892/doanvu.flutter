import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/models/clinic.dart';

abstract class ClinicState extends Equatable {
  const ClinicState();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ClinicStateInitial extends ClinicState {}

class ClinicStateLoading extends ClinicState {}

class ClinicStateSuccess extends ClinicState {
  final ClinicResponse response;
  const ClinicStateSuccess({@required this.response})
      : assert(response != null);
  @override
  List<Object> get props => [response];
}

class ClinicStateFailure extends ClinicState {}

class ClinicStateLogout extends ClinicState {}

class ClinicAddStateSuccess extends ClinicState {
  final ClinicAddResponse response;
  const ClinicAddStateSuccess({this.response}) : assert(response != null);
  @override
  List<Object> get props => [];
}

class ClinicEditStateSuccess extends ClinicState {
  final ClinicEditResponse response;
  const ClinicEditStateSuccess({this.response}) : assert(response != null);
  @override
  List<Object> get props => [];
}

class ClinicDelStateSuccess extends ClinicState {
  final ClinicEditResponse response;
  const ClinicDelStateSuccess({this.response}) : assert(response != null);
  @override
  List<Object> get props => [];
}
