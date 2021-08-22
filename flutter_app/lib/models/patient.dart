import 'package:equatable/equatable.dart';

class Patient extends Equatable {
  final int id;
  final String name;
  final String phone;
  final int dentistId;
  final int clinicId;

  const Patient(
      {this.id, this.name, this.dentistId, this.phone, this.clinicId});

  @override
  // TODO: implement props
  List<Object> get props => [id];

  factory Patient.fromJson(dynamic jsonObject) {
    return Patient(
      id: jsonObject['_id'] ?? '',
      name: jsonObject['name'] ?? '',
      phone: jsonObject['phone'] ?? '',
      dentistId: jsonObject['dentistId'] ?? 0,
      clinicId: jsonObject['clinicId'] ?? 0,
    );
  }

  @override
  String toString() {
    return '$name $phone'.toLowerCase() + '$name $phone'.toUpperCase();
  }
}

class PatientResponse extends Equatable {
  final String status;
  final int statusCode;
  final String message;
  final List<Patient> data;

  const PatientResponse(
      {this.status, this.statusCode, this.message, this.data});

  @override
  // TODO: implement props
  List<Object> get props => [data];

  factory PatientResponse.fromJson(dynamic jsonObject) {
    var list = jsonObject['data'] as List;
    List<Patient> dataList = list.map((i) => Patient.fromJson(i)).toList();
    print('patientList: $dataList');

    return PatientResponse(
      status: jsonObject['status'] ?? '',
      statusCode: jsonObject['statusCode'] ?? 0,
      message: jsonObject['message'] ?? '',
      data: dataList,
    );
  }
}
