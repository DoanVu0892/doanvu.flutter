import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Block extends Equatable {
  final String id;
  final String note;
  final int status;
  final String patientId;
  final String patientName;

  const Block(
      {@required this.id,
      this.note,
      this.status,
      this.patientId,
      this.patientName});

  @override
  // TODO: implement props
  List<Object> get props => [id];

  factory Block.fromJson(dynamic jsonObject) {
    return Block(
      id: jsonObject['_id'] ?? '',
      note: jsonObject['note'] ?? '',
      status: jsonObject['status'] ?? 0,
      patientId: jsonObject['patientId'] ?? '',
      patientName: jsonObject['patientName'] ?? '',
    );
  }
}

class Schedule extends Equatable {
  final int blockId;
  final String booked;
  final String cancelReason;
  final String time;
  final Block block;

  const Schedule(
      {@required this.time,
      this.blockId,
      this.booked,
      this.block,
      this.cancelReason});

  @override
  // TODO: implement props
  List<Object> get props => [blockId];

  //convert JSON to object
  factory Schedule.fromJson(dynamic jsonObject) {
    return Schedule(
      time: jsonObject['time'] ?? '',
      blockId: jsonObject['blockId'] ?? 0,
      cancelReason: jsonObject['cancelReason'] ?? '',
      booked: jsonObject['booked'] ?? '',
      block: Block.fromJson(jsonObject['block']) ?? {},
    );
  }
}

class ScheduleResponse extends Equatable {
  final String status;
  final int statusCode;
  final String message;
  final List<Schedule> data;

  const ScheduleResponse(
      {@required this.status, this.statusCode, this.message, this.data});

  @override
  // TODO: implement props
  List<Object> get props => [data];

  factory ScheduleResponse.fromJson(dynamic jsonObject) {
    var list = jsonObject['data'] as List;
    List<Schedule> dataList = list.map((i) => Schedule.fromJson(i)).toList();

    return ScheduleResponse(
        status: jsonObject['status'] ?? '',
        statusCode: jsonObject['statusCode'] ?? 0,
        message: jsonObject['message'] ?? '',
        data: dataList ?? '');
  }
}
