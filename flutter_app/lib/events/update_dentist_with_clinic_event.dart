import 'package:equatable/equatable.dart';

abstract class UpdateDentistWithClinicEvent extends Equatable {
  const UpdateDentistWithClinicEvent();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class UpdateDentistWithClinicEventRequested
    extends UpdateDentistWithClinicEvent {
  final String date;
  final List<Map<String, dynamic>> listUpdate;

  const UpdateDentistWithClinicEventRequested({this.date, this.listUpdate});
}
