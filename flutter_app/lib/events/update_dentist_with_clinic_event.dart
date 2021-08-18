import 'package:equatable/equatable.dart';

abstract class UpdateDentistWithClinicEvent extends Equatable{
  const UpdateDentistWithClinicEvent();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class UpdateDentistWithClinicEventRequested extends UpdateDentistWithClinicEvent{
  final int dentistId;
  final int clinicId;

  const UpdateDentistWithClinicEventRequested({this.dentistId, this.clinicId});

  @override
  // TODO: implement props
  List<Object> get props => [dentistId];
}