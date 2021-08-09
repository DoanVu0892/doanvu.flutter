import 'package:equatable/equatable.dart';

// ignore: unused_import
import 'base_response.dart';
// ignore: unused_import
import 'dentist.dart';

class User extends Equatable {
  final String name;
  final String phone;
  final String userType;
  final bool status;
  final int clinicId;
  final String clinicName;
  final int dentistId;
  final String dentistName;
  final int id;

  const User(
      {this.phone,
      this.name,
      this.status,
      this.clinicId,
      this.dentistId,
      this.id,
      this.userType,
      this.dentistName,
      this.clinicName});

  @override
  // TODO: implement props
  List<Object> get props => [phone];

  // convert JSON to object
  factory User.fromJson(dynamic jsonObject) {
    return User(
      phone: jsonObject['phone'] ?? '',
      name: jsonObject['name'] ?? '',
      userType: jsonObject['userType'] ?? '',
      status: jsonObject['status'] ?? false,
      clinicId: jsonObject['clinicId'] ?? 0,
      clinicName: jsonObject['clinicName'] ?? '',
      dentistId: jsonObject['dentistId'] ?? 0,
      dentistName: jsonObject['dentistName'] ?? '',
      id: jsonObject['_id'] ?? 0,
    );
  }
}

class Data extends Equatable {
  final String accessToken;
  final String refreshToken;
  final User user;

  const Data({this.accessToken, this.refreshToken, this.user});

  @override
  // TODO: implement props
  List<Object> get props => [user];

  factory Data.fromJson(dynamic jsonObject) {
    return Data(
        accessToken: jsonObject['accessToken'] ?? '',
        refreshToken: jsonObject['refreshToken'] ?? '',
        user: User.fromJson(jsonObject['user']) ?? '');
  }
}

class Response extends Equatable {
  final String status;
  final int statusCode;
  final String message;
  final Data data;

  const Response({this.status, this.statusCode, this.message, this.data});

  @override
  // ignore: todo
  // TODO: implement props
  List<Object> get props => [data];

  factory Response.fromJson(dynamic jsonObject) {
    return Response(
        status: jsonObject['status'] ?? '',
        statusCode: jsonObject['statusCode'] ?? 0, //as double,
        message: jsonObject['message'] ?? '',
        data: Data.fromJson(jsonObject['data']) ?? '');
  }
}
