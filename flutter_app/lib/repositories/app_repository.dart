import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/models/base_response.dart';
import 'package:flutter_app/models/clinic.dart';
import 'package:flutter_app/models/dentist.dart';
import 'package:flutter_app/models/dentist_update.dart';
import 'package:flutter_app/models/feedback.dart';
import 'package:flutter_app/models/history_response.dart';
import 'package:flutter_app/models/leave_schedule.dart';
import 'package:flutter_app/models/notify.dart';
import 'package:flutter_app/models/patient.dart';
import 'package:flutter_app/models/schedule.dart';
import 'package:flutter_app/models/schedule_add.dart';
import 'package:flutter_app/models/user.dart';
import 'package:flutter_app/states/leave_schedule_state.dart';
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
// final _dentistUrl = (clinicId) => '$baseUrl/dentist/$clinicId/byClinic';
final _dentistUrl = '$baseUrl/dentist/list';
final _listWorkUrl = '$baseUrl/dentist/listWork';
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
final _historyUrl = (patientId) => '$baseUrl/history/list?patientId=$patientId';
final _checkLoginUrl = '$baseUrl/info';
final _leaveScheduleUrl = '$baseUrl/leaveSchedule/add';
final _deviceTokenUrl = '$baseUrl/device/add';
final _addUserManagerUrl = '$baseUrl/user/add';
final _getNotifyManager = '$baseUrl/notify/manager';
final _getNotifyCustomer =
    (patientId) => '$baseUrl/notify/list?patientId=$patientId';
final _updateDentist = '$baseUrl/dentist/updateClinic';
//feedback
final _getFeedbackUrl = '$baseUrl/feedback/list';
final _sendFeedbackUrl = '$baseUrl/feedback/add';

class AppRepository {
  http.Client httpClient;

  AppRepository({@required this.httpClient}) : assert(httpClient != null);
  String accessToken;
  bool isLogin = false;
  Map<String, String> headersLogin = {'Content-Type': 'application/json'};

  Future<Response> login(String phoneNumber, String pwd) async {
    httpClient.close();
    httpClient = new http.Client();
    final response = await httpClient.post(_loginUrl,
        body: jsonEncode({'phone': phoneNumber, 'password': pwd}),
        headers: headersLogin);
    if (response.statusCode == 200) {
      print('response ${response.body}');
      Response responseData = Response.fromJson(jsonDecode(response.body));
      accessToken = responseData.data.accessToken;
      isLogin = true;
      httpClient.close();
      return responseData;
    } else {
      print('response ${response.statusCode}');
      httpClient.close();
      throw Exception('Error Login of: $phoneNumber');
    }
  }

  Future<http.Response> sendDeviceToken(String token, String patientId) async {
    httpClient.close();
    httpClient = new http.Client();
    final response = await httpClient.post(_deviceTokenUrl, body: {
      'token': token,
      'patientId': patientId
    }, headers: {
      'Authorization': 'Bearer $accessToken',
    });
    if (response.statusCode == 200) {
      print("${response.statusCode}");
      httpClient.close();
      return response;
    } else if (response.statusCode == 401) {
      throw ('logout');
    } else {
      httpClient.close();
      return response;
    }
  }

  Future<bool> checkLogin() async {
    httpClient.close();
    httpClient = new http.Client();
    print('accessToken: $accessToken');
    final response = await httpClient
        .get(_checkLoginUrl, headers: {'Authorization': 'Bearer $accessToken'});
    if (response.statusCode == 200) {
      httpClient.close();
      return false;
    } else if (response.statusCode == 401) {
      throw ('logout');
    } else {
      httpClient.close();
      return true;
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
    } else if (response.statusCode == 401) {
      throw ('logout');
    } else {
      httpClient.close();
      throw Exception('Error get Clinic of: $accessToken');
    }
  }

  Future<ClinicAddResponse> addClinic(
      String name, String phone, String address) async {
    httpClient = new http.Client();
    final response = await httpClient.post(_addClinic,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: jsonEncode({
          'name': name,
          'phone': phone,
          'address': address,
        }));
    if (response.statusCode == 200) {
      print('response ${response.body}');
      httpClient.close();
      return ClinicAddResponse.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw ('logout');
    } else {
      throw Exception('Error add Clinic of: $accessToken');
    }
  }

  Future<ClinicEditResponse> editClinic(
      int clinicId, String name, String phone, String address) async {
    httpClient = new http.Client();
    final response = await httpClient.put(_editClinic(clinicId),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: jsonEncode({
          'status': 1,
          'name': name,
          'phone': phone,
          'address': address,
        }));
    if (response.statusCode == 200) {
      print('response ${response.body}');
      httpClient.close();
      return ClinicEditResponse.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw ('logout');
    } else {
      throw Exception('Error edit Clinic of: $clinicId');
    }
  }

  Future<ClinicEditResponse> delClinic(int clinicId) async {
    httpClient = new http.Client();
    print('del: ${_delClinic(clinicId)}');
    final response = await httpClient.put(_delClinic(clinicId),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: jsonEncode({}));
    if (response.statusCode == 200) {
      print('response ${response.body}');
      httpClient.close();
      return ClinicEditResponse.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw ('logout');
    } else {
      throw Exception('Error del Clinic of: $clinicId');
    }
  }

  //

  Future<DentistResponse> getDentist() async {
    httpClient.close();
    httpClient = new http.Client();
    print('url: $_dentistUrl');
    final response = await httpClient
        .get(_dentistUrl, headers: {'Authorization': 'Bearer $accessToken'});
    if (response.statusCode == 200) {
      print('response ${response.body}');
      httpClient.close();
      return DentistResponse.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw ('logout');
    } else {
      httpClient.close();
      throw Exception('Error get Dentist of:');
    }
  }

  Future<BaseResponse> addDentist(
      int clinicId, String name, String phone) async {
    httpClient = new http.Client();
    final response = await httpClient.post(_addDentistUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: jsonEncode({'clinicId': clinicId, 'name': name, 'phone': phone}));
    if (response.statusCode == 200) {
      httpClient.close();
      print('res: ${response.body}');
      return BaseResponse.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw ('logout');
    } else {
      httpClient.close();
      throw Exception('Error add Dentist of: $clinicId');
    }
  }

  Future<BaseResponse> editDentist(
      int dentistId, String name, String phone) async {
    httpClient = new http.Client();
    final response = await httpClient.put(_editDentistUrl(dentistId),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: jsonEncode({'name': name, 'phone': phone}));
    if (response.statusCode == 200) {
      httpClient.close();
      print('res: ${response.body}');
      return BaseResponse.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw ('logout');
    } else {
      httpClient.close();
      throw Exception('Error edit Dentist of: $dentistId');
    }
  }

  Future<BaseResponse> delDentist(int dentistId) async {
    httpClient = new http.Client();
    final response = await httpClient.put(_delDentistUrl(dentistId),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: jsonEncode({}));
    if (response.statusCode == 200) {
      httpClient.close();
      print('res: ${response.body}');
      return BaseResponse.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw ('logout');
    } else {
      httpClient.close();
      throw Exception('Error del Dentist of: $dentistId');
    }
  }

  //schedule

  Future<ScheduleResponse> getScheduleList(
      int dentistId, String appointmentDate, String workShift) async {
    httpClient = new http.Client();
    print('url: ${_scheduleUrl(dentistId, appointmentDate, workShift)}');
    final response = await httpClient.get(
        _scheduleUrl(dentistId, appointmentDate, workShift),
        headers: {'Authorization': 'Bearer $accessToken'});
    if (response.statusCode == 200) {
      print('response ${response.body}');
      httpClient.close();
      return ScheduleResponse.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw ('logout');
    } else {
      httpClient.close();
      throw Exception('Error get Schedule of: $dentistId');
    }
  }

  Future<ScheduleAddResponse> addScheduleList(
      int patientId,
      String patientName,
      int dentistId,
      String appointmentDate,
      String note,
      int blockId,
      int clinicId) async {
    httpClient = new http.Client();
    print('send: ${jsonEncode({
          'patientId': patientId,
          'patientName': patientName,
          'dentistId': dentistId,
          'appointmentDate': appointmentDate,
          'note': note,
          'blockId': blockId,
          'clinicId': clinicId,
        })}');
    final response = await httpClient.post(_addScheduleUrl,
        body: jsonEncode({
          'patientId': patientId,
          'patientName': patientName,
          'dentistId': dentistId,
          'appointmentDate': appointmentDate,
          'note': note,
          'blockId': blockId,
          'clinicId': clinicId,
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
    } else if (response.statusCode == 401) {
      throw ('logout');
    } else {
      httpClient.close();
      throw Exception('Error add Schedule with: $patientId');
    }
  }

  Future<ResLeaveSchedule> setLeaveSchedule(int dentistId, String startDate,
      String endDate, String shiftWork, String reason) async {
    httpClient = new http.Client();
    print(jsonEncode({
      'dentistId': dentistId,
      'startDate': startDate,
      'endDate': endDate,
      'shiftWork': shiftWork,
      'reason': reason,
    }));
    final response = await httpClient.post(_leaveScheduleUrl,
        body: jsonEncode({
          'dentistId': dentistId,
          'startDate': startDate,
          'endDate': endDate,
          'shiftWork': shiftWork,
          'reason': reason,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $accessToken'
        });
    if (response.statusCode == 200) {
      httpClient.close();
      print('rsponse: ${response.body}');
      return ResLeaveSchedule.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw ('logout');
    } else {
      throw Exception('Error set LeaveSchedule: $dentistId');
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
    } else if (response.statusCode == 401) {
      throw ('logout');
    } else {
      print('response ${response.body} ${response.statusCode}');
      httpClient.close();
      throw Exception('Error cancel Schedule with: $reason');
    }
  }

  Future<PatientResponse> getPatients(int dentistId) async {
    httpClient = new http.Client();
    final response = await httpClient.get(_patientUrl(dentistId),
        headers: {'Authorization': 'Bearer $accessToken'});
    if (response.statusCode == 200) {
      httpClient.close();
      print('response ${response.body}');
      return PatientResponse.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw ('logout');
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
    } else if (response.statusCode == 401) {
      throw ('logout');
    } else {
      httpClient.close();
      throw Exception('Error search Parients of: $dentistId');
    }
  }

  Future<HistoryResponse> getHistory(int patientId) async {
    httpClient = new http.Client();
    final response = await httpClient.get(_historyUrl(patientId),
        headers: {'Authorization': 'Bearer $accessToken'});
    if (response.statusCode == 200) {
      httpClient.close();
      print('response ${response.body}');
      return HistoryResponse.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw ('logout');
    } else {
      httpClient.close();
      throw Exception('Error getHistory of: $patientId');
    }
  }

  Future<BaseResponse> addUserManager(
      String phone, String password, String name, String clinicId) async {
    httpClient.close();
    httpClient = http.Client();
    final response = await httpClient.post(_addUserManagerUrl, body: {
      'phone': phone,
      'password': password,
      'name': name,
      'clinicId': clinicId,
    }, headers: {
      'Authorization': 'Bearer $accessToken'
    });
    if (response.statusCode == 200) {
      httpClient.close();
      return BaseResponse.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw ('logout');
    } else {
      httpClient.close();
      throw Exception('add user manager failure!');
    }
  }

  //notify

  Future<ResponseNotify> getNotifyManager() async {
    httpClient.close();
    httpClient = http.Client();
    final response = await httpClient.get(_getNotifyManager,
        headers: {'Authorization': 'Bearer $accessToken'});
    if (response.statusCode == 200) {
      httpClient.close();
      print('resnoti1: ${response.body}');
      return ResponseNotify.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw ('logout');
    } else {
      httpClient.close();
      throw Exception('getNotify manager fail');
    }
  }

  Future<ResponseNotifyCM> getNotifyCustomer(String patientId) async {
    httpClient.close();
    httpClient = http.Client();
    print(_getNotifyCustomer(patientId));
    final response = await httpClient.get(_getNotifyCustomer(patientId),
        headers: {'Authorization': 'Bearer $accessToken'});
    if (response.statusCode == 200) {
      httpClient.close();
      print('res2: ${response.body}');
      return ResponseNotifyCM.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw ('logout');
    } else {
      httpClient.close();
      throw Exception('getNotify customer fail');
    }
  }

  //update dentist with clinicId

  Future<BaseResponse> updateDentistWithClinicId(
      List<Map<String, dynamic>> listUpdate, String date) async {
    httpClient.close();
    httpClient = http.Client();
    print('abc: $listUpdate');
    print(jsonEncode(listUpdate));
    final response = await httpClient.put(_updateDentist,
        body: jsonEncode({'date': date, 'work': listUpdate}),
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json"
        });
    if (response.statusCode == 200) {
      httpClient.close();
      return BaseResponse.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw ('logout');
    } else {
      httpClient.close();
      throw Exception('update Dentist failure');
    }
  }

  //listWork
  Future<ResponseUpdateDentist> getListWork() async {
    httpClient.close();
    httpClient = http.Client();
    final response = await httpClient
        .get(_listWorkUrl, headers: {'Authorization': 'Bearer $accessToken'});
    if (response.statusCode == 200) {
      httpClient.close();
      return ResponseUpdateDentist.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw ('logout');
    } else {
      httpClient.close();
      throw Exception('get list work failure');
    }
  }

  //feeback
  Future<ResponseFeedback> getFeedBack() async {
    httpClient.close();
    httpClient = http.Client();
    final response = await httpClient.get(_getFeedbackUrl,
        headers: {'Authorization': 'Bearer $accessToken'});
    print('response ${response.body}');
    if (response.statusCode == 200) {
      httpClient.close();
      return ResponseFeedback.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      httpClient.close();
      throw ('logout');
    } else {
      httpClient.close();
      throw Exception('get feedback failure');
    }
  }

  Future<BaseResponse> sendFeedback(String patientId, String patientName,
      String title, String content) async {
    httpClient.close();
    httpClient = http.Client();
    final response = await httpClient.post(_sendFeedbackUrl, body: {
      'patientId': patientId,
      'patientName': patientName,
      'title': title,
      'content': content,
    }, headers: {
      'Authorization': 'Bearer $accessToken'
    });
    print('response ${response.body}');
    if (response.statusCode == 200) {
      httpClient.close();
      return BaseResponse.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw ('logout');
    } else {
      httpClient.close();
      throw Exception('get feedback failure');
    }
  }
}
