import 'package:equatable/equatable.dart';

import 'base_response.dart';
import 'dentist.dart';

class User extends Equatable {
  final String name;
  final String phone;
  final String userType;
  final int status;
  final String clinicId;
  final String clinicName;
  final String dentistId;
  final String dentistName;
  final String id;

  const User({this.phone, this.name, this.status, this.clinicId, this.dentistId, this.id, this.userType, this.dentistName, this.clinicName});

  @override
  // TODO: implement props
  List<Object> get props => [phone];

  // convert JSON to object
  factory User.fromJson(dynamic jsonObject){
    return User(
      phone: jsonObject['phone'] ?? '',
      name: jsonObject['name'] ?? '',
      userType: jsonObject['userType'] ?? '',
      status: jsonObject['status'] ?? 0,
      clinicId: jsonObject['clinicId'] ?? '',
      clinicName: jsonObject['clinicName'] ?? '',
      dentistId: jsonObject['dentistId'] ?? '',
      dentistName: jsonObject['dentistName'] ?? '',
      id: jsonObject['_id'] ?? '',
    );
  }
}

class Data extends Equatable{
  final String accessToken;
  final String refreshToken;
  final User user;

  const Data({ this.accessToken, this.refreshToken, this.user});

  @override
  // TODO: implement props
  List<Object> get props => [user];

  factory Data.fromJson(dynamic jsonObject){
    return Data(
      accessToken: jsonObject['accessToken'] ?? '',
      refreshToken: jsonObject['refreshToken'] ?? '',
      user: User.fromJson(jsonObject['user']) ?? ''
    );
  }
}

class Response extends Equatable{
  final String status;
  final int statusCode;
  final String message;
  final Data data;

  const Response({ this.status, this.statusCode, this.message, this.data});

  @override
  // TODO: implement props
  List<Object> get props => [data];

  factory Response.fromJson(dynamic jsonObject){
    return Response(
      status: jsonObject['status'] ?? '',
      statusCode: jsonObject['statusCode'] ?? 0 ,//as double,
      message: jsonObject['message'] ?? '',
      data: Data.fromJson(jsonObject['data']) ?? ''
    );
  }
}
