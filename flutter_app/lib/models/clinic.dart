import 'dart:convert';

import 'package:equatable/equatable.dart';

class Clinic extends Equatable {
  final int status;
  final String id;
  final String name;
  final String phone;
  final String address;

  const Clinic({this.status, this.id, this.name, this.phone, this.address});

  @override
  // TODO: implement props
  List<Object> get props => [id];

  factory Clinic.fromJson(dynamic jsonObject) {
    return Clinic(
      status: jsonObject['status'] ?? 0,
      id: jsonObject['_id'] ?? '',
      name: jsonObject['name'] ?? '',
      phone: jsonObject['phone'] ?? '',
      address: jsonObject['address'] ?? '',
    );
  }
}

class ClinicResponse extends Equatable {
  final String status;
  final int statusCode;
  final String message;
  final List<Clinic> dataList;

  const ClinicResponse({this.status, this.message, this.statusCode, this.dataList});

  @override
  // TODO: implement props
  List<Object> get props => [dataList];

  factory ClinicResponse.fromJson(dynamic jsonObject) {

    var list = jsonObject['data'] as List;
    List<Clinic> dataList = list.map((i) => Clinic.fromJson(i)).toList();

    return ClinicResponse(
        status: jsonObject['status'] ?? '',
        statusCode: jsonObject['statusCode'] ?? 0,
        message: jsonObject['message'] ?? '',
        dataList: dataList ?? ''
    );
  }
}
class ClinicAddResponse extends Equatable{
  final String name;
  final String phone;
  final String address;

  const ClinicAddResponse({
    this.name, this.phone, this.address
});
  @override
  // TODO: implement props
  List<Object> get props => [phone];

  factory ClinicAddResponse.fromJson(dynamic jsonObject){
    return ClinicAddResponse(
      name: jsonObject['name'] ?? '',
      phone: jsonObject['phone'] ?? '',
      address: jsonObject['address'] ?? '',
    );
  }
}

class ClinicEditResponse extends Equatable{
  final String status;
  final int statusCode;
  final String message;

  const ClinicEditResponse({
    this.statusCode, this.status, this.message
  });
  @override
  // TODO: implement props
  List<Object> get props => [];

  factory ClinicEditResponse.fromJson(dynamic jsonObject){
    return ClinicEditResponse(
      status: jsonObject['status'] ?? '',
      statusCode: jsonObject['statusCode'] ?? 0,
      message: jsonObject['message'] ?? '',
    );
  }
}