import 'package:equatable/equatable.dart';
import 'package:flutter_app/models/base_response.dart';

class Notify extends Equatable {
  final String id;
  final String token;
  final String patientId;
  final String title;
  final String message;
  final String date;
  final String time;
  final String type;

  const Notify(
      {this.id,
      this.token,
      this.patientId,
      this.title,
      this.message,
      this.date,
      this.time,
      this.type});

  @override
  // TODO: implement props
  List<Object> get props => [id];

  factory Notify.fromJSON(dynamic jsonObject) {
    return Notify(
      id: jsonObject['_id'] ?? '',
      token: jsonObject['token'] ?? '',
      patientId: jsonObject['patientId'] ?? '',
      title: jsonObject['title'] ?? '',
      message: jsonObject['message'] ?? '',
      date: jsonObject['date'] ?? '',
      time: jsonObject['time'] ?? '',
      type: jsonObject['type'] ?? '',
    );
  }
}

class ResponseNotify extends BaseResponse {
  final List<Notify> dataNotify;

  const ResponseNotify({this.dataNotify});

  @override
  // TODO: implement props
  List<Object> get props => [dataNotify];

  factory ResponseNotify.fromJson(dynamic jsonObject) {
    var list = jsonObject['data'] as List;
    List<Notify> dataNotify = list.map((i) => Notify.fromJSON(i)).toList();

    return ResponseNotify(dataNotify: dataNotify);
  }
}

class ResponseNotifyCM extends BaseResponse {
  final List<Notify> dataNotify;

  const ResponseNotifyCM({this.dataNotify});

  @override
  // TODO: implement props
  List<Object> get props => [dataNotify];

  factory ResponseNotifyCM.fromJson(dynamic jsonObject) {
    var list = jsonObject['data'] as List;
    List<Notify> dataNotify = list.map((i) => Notify.fromJSON(i)).toList();

    return ResponseNotifyCM(dataNotify: dataNotify);
  }
}
