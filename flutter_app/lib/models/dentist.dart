import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'base_response.dart';

class DentistData extends Equatable {
  final int status;
  final int id;
  final String name;
  final String phone;
  final int clinicId;
  final int count;

  const DentistData(
      {this.status, this.id, this.name, this.phone, this.clinicId, this.count});

  @override
  // TODO: implement props
  List<Object> get props => [id];

  factory DentistData.fromJson(dynamic jsonObject) {
    return DentistData(
      status: jsonObject['status'] ?? 0,
      id: jsonObject['_id'] ?? 0,
      name: jsonObject['name'] ?? '',
      phone: jsonObject['phone'] ?? '',
      clinicId: jsonObject['ClinicId'] ?? 0,
      count: jsonObject['count'] ?? 0,
    );
  }
}

class DentistResponse extends BaseResponse {
  final List<DentistData> dataList;

  const DentistResponse({this.dataList});

  @override
  // TODO: implement props
  List<Object> get props => [dataList];

  factory DentistResponse.fromJson(dynamic jsonObject) {
    var list = jsonObject['data'] as List;
    List<DentistData> dataList =
        list.map((i) => DentistData.fromJson(i)).toList();

    return DentistResponse(dataList: dataList ?? '');
  }
}
