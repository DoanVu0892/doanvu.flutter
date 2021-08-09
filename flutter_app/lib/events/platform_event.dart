import 'package:equatable/equatable.dart';

abstract class PlatformEvent extends Equatable{
  const PlatformEvent();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class PlatformEventRequested extends PlatformEvent{
  String token;
  int patientId;

  PlatformEventRequested({ this.token, this.patientId});

  @override
  // TODO: implement props
  List<Object> get props => [patientId];
}