
import 'package:equatable/equatable.dart';

class ScheduleAddResponseData extends Equatable {
  final int status;
  final String id;
  final String parientId;
  final String parientName;
  final String dentistId;
  final String appointmentDate;
  final String note;
  final int blockId;

  const ScheduleAddResponseData(
      {this.status,
        this.id,
        this.parientId,
        this.parientName,
        this.dentistId,
        this.appointmentDate,
        this.note,
        this.blockId});

  @override
  // TODO: implement props
  List<Object> get props => [id];

  factory ScheduleAddResponseData.fromJson(dynamic jsonObject) {
    return ScheduleAddResponseData(
      status: jsonObject['status'] ?? 0,
      id: jsonObject['_id'] ?? '',
      parientId: jsonObject['parientId'] ?? '',
      parientName: jsonObject['parientName'] ?? '',
      dentistId: jsonObject['dentistId'] ?? '',
      appointmentDate: jsonObject['appointmentDate'] ?? '',
      note: jsonObject['note'] ?? '',
      blockId: jsonObject['blockId'] ?? 0,
    );
  }
}

class ScheduleAddResponse extends Equatable {
  final String status;
  final int statusCode;
  final String message;
  final ScheduleAddResponseData data;

  const ScheduleAddResponse(
      {this.status, this.statusCode, this.data, this.message});

  @override
  // TODO: implement props
  List<Object> get props => [data];

  factory ScheduleAddResponse.fromJson(dynamic jsonObject) {
    return ScheduleAddResponse(
      status: jsonObject['status'] ?? '',
      statusCode: jsonObject['statusCode'] ?? 0,
      message: jsonObject['message'] ?? '',
      data: ScheduleAddResponseData.fromJson(jsonObject['data']) ?? '',
    );
  }
}
class ScheduleDelResponse extends Equatable {
  final String status;
  final int statusCode;
  final String message;

  const ScheduleDelResponse(
      {this.status, this.statusCode, this.message});

  @override
  // TODO: implement props
  List<Object> get props => [];

  factory ScheduleDelResponse.fromJson(dynamic jsonObject) {
    return ScheduleDelResponse(
      status: jsonObject['status'] ?? '',
      statusCode: jsonObject['statusCode'] ?? 0,
      message: jsonObject['message'] ?? '',
    );
  }
}