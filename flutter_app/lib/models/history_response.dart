import 'package:equatable/equatable.dart';
import 'base_response.dart';

class History extends Equatable {
  final int status;
  final String id;
  final String appointmentDate;
  final String note;
  final String time;
  final String reason;

  const History(
      {this.status,
      this.id,
      this.appointmentDate,
      this.note,
      this.time,
      this.reason});

  @override
  // TODO: implement props
  List<Object> get props => [id];

  factory History.fromJson(dynamic jsonObject) {
    return History(
      status: jsonObject['status'] ?? -1,
      id: jsonObject['_id'] ?? '',
      appointmentDate: jsonObject['appointmentDate'] ?? '',
      note: jsonObject['note'] ?? '',
      time: jsonObject['time'] ?? '',
      reason: jsonObject['reason'] ?? '',
    );
  }
}

class HistoryResponse extends BaseResponse {
  final List<History> dataHistory;

  const HistoryResponse({this.dataHistory});

  @override
  // TODO: implement props
  List<Object> get props => [dataHistory];

  factory HistoryResponse.fromJson(dynamic jsonObject){

    var list = jsonObject['data'] as List;
    List<History> dataHistory = list.map((i) => History.fromJson(i)).toList();

    return HistoryResponse( dataHistory: dataHistory);
  }
}
