import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/models/dentist.dart';

abstract class DentistState extends Equatable {
  const DentistState();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class DentistStateInitial extends DentistState {}

class DentistStateLoading extends DentistState {}

class DentistStateSuccess extends DentistState {
  final DentistResponse response;

  const DentistStateSuccess({@required this.response})
      : assert(response != null);

  @override
  // TODO: implement props
  List<Object> get props => [response];
}
class DentistAddStateSuccess extends DentistState {
  final BaseResponse response;

  const DentistAddStateSuccess({@required this.response})
      : assert(response != null);

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class DentistEditStateSuccess extends DentistState {
  final BaseResponse response;

  const DentistEditStateSuccess({@required this.response})
      : assert(response != null);

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class DentistDelStateSuccess extends DentistState {
  final BaseResponse response;

  const DentistDelStateSuccess({@required this.response})
      : assert(response != null);

  @override
  // TODO: implement props
  List<Object> get props => [response];
}


class DentistStateFailure extends DentistState {}
