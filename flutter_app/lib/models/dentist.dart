import 'dart:convert';

import 'package:equatable/equatable.dart';

class DentistData extends Equatable {
  final int status;
  final String id;
  final String name;
  final String phone;
  final String clinicId;

  const DentistData({this.status, this.id, this.name, this.phone, this.clinicId});

  @override
  // TODO: implement props
  List<Object> get props => [id];

  factory DentistData.fromJson(dynamic jsonObject) {
    return DentistData(
      status: jsonObject['status'] ?? 0,
      id: jsonObject['_id'] ?? '',
      name: jsonObject['name'] ?? '',
      phone: jsonObject['phone'] ?? '',
      clinicId: jsonObject['clinicId'] ?? '',
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
    List<DentistData> dataList = list.map((i) => DentistData.fromJson(i)).toList();

    return DentistResponse(
        dataList: dataList ?? ''
    );
  }
}

class BaseResponse extends Equatable {
  final String status;
  final int statusCode;
  final String message;

  const BaseResponse({this.status, this.message, this.statusCode});

  @override
  // TODO: implement props
  List<Object> get props => [];
  factory BaseResponse.fromJson(dynamic jsonObject){
    return BaseResponse(
      status: jsonObject['status'] ?? '',
      statusCode: jsonObject['statusCode'] ?? 0,
      message: jsonObject['message'] ?? '',
    );
  }
}
