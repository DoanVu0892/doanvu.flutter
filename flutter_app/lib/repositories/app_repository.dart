import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/models/clinic.dart';
import 'package:flutter_app/models/dentist.dart';
import 'package:flutter_app/models/patient.dart';
import 'package:flutter_app/models/schedule.dart';
import 'package:flutter_app/models/schedule_add.dart';
import 'package:flutter_app/models/user.dart';
import 'package:http/http.dart' as http;

const baseUrl = 'http://171.244.132.41:9443';
final loginUrl = (phoneNumber, pwd) =>
    '$baseUrl/login/phoneNumber=$phoneNumber&password=$pwd';
final _loginUrl = '$baseUrl/user/login';
//clinic
final _branchUrl = '$baseUrl/clinic/list';
final _addClinic = '$baseUrl/clinic/add';
final _editClinic = (clinicId) => '$baseUrl/clinic/$clinicId/edit';
final _delClinic = (clinicId) => '$baseUrl/clinic/$clinicId/delete';
//dentist
final _dentistUrl = (clinicId) => '$baseUrl/dentist/$clinicId/byClinic';
final _addDentistUrl = '$baseUrl/dentist/add';
final _editDentistUrl = (dentistId) => '$baseUrl/dentist/$dentistId/edit';
final _delDentistUrl = (dentistId) => '$baseUrl/dentist/$dentistId/delete';
//schedule
final _scheduleUrl = (dentistId, appointmentDate, workShift) =>
    '$baseUrl/schedule/list?dentistId=$dentistId&appointmentDate=$appointmentDate&workShift=$workShift';
final _addScheduleUrl = '$baseUrl/schedule/add';
final _cancelScheduleUrl = (bookedId) => '$baseUrl/schedule/$bookedId/cancel';
//patient
final _patientUrl = (dentistId) => '$baseUrl/patient/$dentistId/byDentist';
final _patientSearchUrl =
    (dentistId, keyWord) => '$_patientUrl?search=$keyWord';

class AppRepository {
  http.Client httpClient;

  AppRepository({@required this.httpClient}) : assert(httpClient != null);
  String accessToken;
  Map<String, String> headersLogin = {'Content-Type': 'application/json'};

  Future<Response> login(String phoneNumber, String pwd) async {
    final response = await httpClient.post(_loginUrl,
        body: jsonEncode({'phone': phoneNumber, 'password': pwd}),
        headers: headersLogin);
    if (response.statusCode == 200) {
      print('response ${response.body}');
      Response responseData = Response.fromJson(jsonDecode(response.body));
      accessToken = responseData.data.accessToken;
      httpClient.close();
      return responseData;
    } else {
      httpClient.close();
      throw Exception('Error Login of: $phoneNumber');
    }
  }
  //clinic

  Future<ClinicResponse> getClinic() async {
    httpClient = new http.Client();
    print('url: $_branchUrl');
    final response = await httpClient
        .get(_branchUrl, headers: {'Authorization': 'Bearer $accessToken'});
    if (response.statusCode == 200) {
      print('response ${response.body}');
      httpClient.close();
      return ClinicResponse.fromJson(jsonDecode(response.body));
    } else {
      httpClient.close();
      throw Exception('Error get Clinic of: $accessToken');
    }
  }

  Future<ClinicAddResponse> addClinic(String name, String phone, String address) async {
    httpClient = new http.Client();
    final response = await httpClient.post(_addClinic,headers:{'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken'}, body: jsonEncode({
      'name' : name,
      'phone' : phone,
      'address' : address,
    }) );
    if(response.statusCode == 200){
      print('response ${response.body}');
      httpClient.close();
          return ClinicAddResponse.fromJson(jsonDecode(response.body));
    }else{
      throw Exception('Error add Clinic of: $accessToken');
    }
  }

  Future<ClinicEditResponse> editClinic(String clinicId, String name, String phone, String address) async {
    httpClient = new http.Client();
    final response = await httpClient.put(_editClinic(clinicId),headers:{'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken'}, body: jsonEncode({
      'status' : 1,
      'name' : name,
      'phone' : phone,
      'address' : address,
    }) );
    if(response.statusCode == 200){
      print('response ${response.body}');
      httpClient.close();
      return ClinicEditResponse.fromJson(jsonDecode(response.body));
    }else{
      throw Exception('Error edit Clinic of: $clinicId');
    }
  }

  Future<ClinicEditResponse> delClinic(String clinicId) async {
    httpClient = new http.Client();
    print('del: ${_delClinic(clinicId)}');
    final response = await httpClient.put(_delClinic(clinicId),headers:{'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken'}, body: jsonEncode({}) );
    if(response.statusCode == 200){
      print('response ${response.body}');
      httpClient.close();
      return ClinicEditResponse.fromJson(jsonDecode(response.body));
    }else{
      throw Exception('Error del Clinic of: $clinicId');
    }
  }

  //

  Future<DentistResponse> getDentist(String clinicId) async {
    httpClient = new http.Client();
    print('url: ${_dentistUrl(clinicId)}');
    final response = await httpClient.get(_dentistUrl(clinicId),
        headers: {'Authorization': 'Bearer $accessToken'});
    if (response.statusCode == 200) {
      print('response ${response.body}');
      httpClient.close();
      return DentistResponse.fromJson(jsonDecode(response.body));
    } else {
      httpClient.close();
      throw Exception('Error get Dentist of: $clinicId');
    }
  }

  Future<BaseResponse> addDentist(String clinicId, String name, String phone) async {
    httpClient = new http.Client();
    final response = await httpClient.post(_addDentistUrl,headers: {'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken'}, body: jsonEncode({
      'clinicId' : clinicId,
      'name' : name,
      'phone' : phone
    }));
    if(response.statusCode == 200){
      httpClient.close();
      print('res: ${response.body}');
      return BaseResponse.fromJson(jsonDecode(response.body));
    }else {
      httpClient.close();
      throw Exception('Error add Dentist of: $clinicId');
    }
  }

  Future<BaseResponse> editDentist(String dentistId, String name, String phone) async {
    httpClient = new http.Client();
    final response = await httpClient.put(_editDentistUrl(dentistId),headers: {'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken'}, body: jsonEncode({
      'name' : name,
      'phone' : phone
    }));
    if(response.statusCode == 200){
      httpClient.close();
      print('res: ${response.body}');
      return BaseResponse.fromJson(jsonDecode(response.body));
    }else {
      httpClient.close();
      throw Exception('Error edit Dentist of: $dentistId');
    }
  }

  Future<BaseResponse> delDentist(String dentistId) async {
    httpClient = new http.Client();
    final response = await httpClient.put(_delDentistUrl(dentistId),headers: {'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken'}, body: jsonEncode({
    }));
    if(response.statusCode == 200){
      httpClient.close();
      print('res: ${response.body}');
      return BaseResponse.fromJson(jsonDecode(response.body));
    }else {
      httpClient.close();
      throw Exception('Error del Dentist of: $dentistId');
    }
  }

  //schedule

  Future<ScheduleResponse> getScheduleList(
      String dentistId, String appointmentDate, String workShift) async {
    httpClient = new http.Client();
    print('url: ${_scheduleUrl(dentistId, appointmentDate, workShift)}');
    final response = await httpClient.get(
        _scheduleUrl(dentistId, appointmentDate, workShift),
        headers: {'Authorization': 'Bearer $accessToken'});
    if (response.statusCode == 200) {
      print('response ${response.body}');
      httpClient.close();
      return ScheduleResponse.fromJson(jsonDecode(response.body));
    } else {
      httpClient.close();
      throw Exception('Error get Schedule of: $dentistId');
    }
  }

  Future<ScheduleAddResponse> addScheduleList(
      String patientId,
      String patientName,
      String dentistId,
      String appointmentDate,
      String note,
      int blockId) async {
    httpClient = new http.Client();
    print('send: ${jsonEncode({
          'patientId': patientId,
          'patientName': patientName,
          'dentistId': dentistId,
          'appointmentDate': appointmentDate,
          'note': note,
          'blockId': blockId
        })}');
    final response = await httpClient.post(_addScheduleUrl,
        body: jsonEncode({
          'patientId': patientId,
          'patientName': patientName,
          'dentistId': dentistId,
          'appointmentDate': appointmentDate,
          'note': note,
          'blockId': blockId
        }),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $accessToken'
        });
    if (response.statusCode == 200) {
      httpClient.close();
      print('response ${response.body}');
      return ScheduleAddResponse.fromJson(jsonDecode(response.body));
    } else {
      httpClient.close();
      throw Exception('Error add Schedule with: $patientId}');
    }
  }

  Future<ScheduleDelResponse> cancelBook(String bookedId, String reason) async {
    httpClient = new http.Client();
    print('cancelUrl: ${_cancelScheduleUrl(bookedId)}');
    final response = await httpClient.put(_cancelScheduleUrl(bookedId),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: jsonEncode({
          'reason': reason,
        }));
    if (response.statusCode == 200) {
      httpClient.close();
      print('response ${response.body}');
      return ScheduleDelResponse.fromJson(jsonDecode(response.body));
    } else {
      print('response ${response.body} ${response.statusCode}');
      httpClient.close();
      throw Exception('Error cancel Schedule with: $reason}');
    }
  }

  Future<PatientResponse> getPatients(String dentistId) async {
    httpClient = new http.Client();
    final response = await httpClient.get(_patientUrl(dentistId),
        headers: {'Authorization': 'Bearer $accessToken'});
    if (response.statusCode == 200) {
      httpClient.close();
      print('response ${response.body}');
      return PatientResponse.fromJson(jsonDecode(response.body));
    } else {
      httpClient.close();
      throw Exception('Error get Parients of: $dentistId');
    }
  }

  Future<PatientResponse> searchPatient(
      String dentistId, String keyWord) async {
    httpClient = new http.Client();
    final response = await httpClient.get(_patientSearchUrl(dentistId, keyWord),
        headers: {'Authorization': 'Bearer $accessToken'});
    if (response.statusCode == 200) {
      httpClient.close();
      print('response ${response.body}');
      return PatientResponse.fromJson(jsonDecode(response.body));
    } else {
      httpClient.close();
      throw Exception('Error search Parients of: $dentistId');
    }
  }
}
