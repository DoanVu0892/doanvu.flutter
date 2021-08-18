import 'package:equatable/equatable.dart';
import 'package:flutter_app/models/base_response.dart';

abstract class UpdateDentistWithClinicState extends Equatable{
  const UpdateDentistWithClinicState();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class UpdateDentistWithClinicInitial extends UpdateDentistWithClinicState{}
class UpdateDentistWithClinicLoading extends UpdateDentistWithClinicState{}
class UpdateDentistWithClinicSuccess extends UpdateDentistWithClinicState{
  final BaseResponse response;
  UpdateDentistWithClinicSuccess({this.response});
  @override
  // TODO: implement props
  List<Object> get props => [response];
}
class UpdateDentistWithClinicFailure extends UpdateDentistWithClinicState{}