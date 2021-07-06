import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/models/base_response.dart';

class LeaveSchedule extends Equatable {
  final int status;
  final String id;
  final String dentistId;
  final String startDate;
  final String endDate;
  final String shiftWork;
  final String reason;

  const LeaveSchedule(
      {@required this.status,
      this.id,
      this.dentistId,
      this.startDate,
      this.endDate,
      this.shiftWork,
      this.reason});

  @override
  // TODO: implement props
  List<Object> get props => [id];

  factory LeaveSchedule.fromJson(dynamic jsonObject) {
    return LeaveSchedule(
      status: jsonObject['status'] ?? 0,
      id: jsonObject['_id'] ?? '',
      dentistId: jsonObject['dentistId'] ?? '',
      startDate: jsonObject['startDate'] ?? '',
      endDate: jsonObject['endDate'] ?? '',
      shiftWork: jsonObject['shiftWork'] ?? '',
      reason: jsonObject['reason'] ?? '',
    );
  }
}

class ResLeaveSchedule extends BaseResponse {
  final int status2;
  final String id;
  final String dentistId;
  final String startDate;
  final String endDate;
  final String shiftWork;
  final String reason;

  const ResLeaveSchedule(
      {@required this.status2,
      this.id,
      this.dentistId,
      this.startDate,
      this.endDate,
      this.shiftWork,
      this.reason});

  // const ResLeaveSchedule({@required this.data});
  @override
  // TODO: implement props
  List<Object> get props => [id];

  factory ResLeaveSchedule.fromJson(dynamic jsonObject) {
    final data = Map<String, dynamic>.from(jsonObject['data']);
    print('data ${jsonEncode(data)}');
    return ResLeaveSchedule(
      status2: data['status'],
      id: data['_id'],
      dentistId: data['dentistId'],
      startDate: data['startDate'],
      endDate: data['endDate'],
      shiftWork: data['shiftWork'],
      reason: data['reason'],
    );
  }
}
