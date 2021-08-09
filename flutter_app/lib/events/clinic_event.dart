import 'package:equatable/equatable.dart';

abstract class ClinicEvent extends Equatable {
  const ClinicEvent();
}

class ClinicEventRequested extends ClinicEvent {
  const ClinicEventRequested();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ClinicAddEventRequested extends ClinicEvent {
  final String name;
  final String phone;
  final String address;

  const ClinicAddEventRequested({this.name, this.phone, this.address});
  @override
  // TODO: implement props
  List<Object> get props => [phone];
}

class ClinicEditEventRequested extends ClinicEvent {
  final int clinicId;
  final String name;
  final String phone;
  final String address;

  const ClinicEditEventRequested(
      {this.clinicId, this.name, this.phone, this.address});
  @override
  // TODO: implement props
  List<Object> get props => [clinicId];
}

class ClinicDelEventRequested extends ClinicEvent {
  final int clinicId;

  const ClinicDelEventRequested({
    this.clinicId,
  });
  @override
  // TODO: implement props
  List<Object> get props => [clinicId];
}
