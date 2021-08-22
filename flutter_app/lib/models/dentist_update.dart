import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_app/models/base_response.dart';

class ResponseUpdateDentist extends BaseResponse {
  UpdateData updateData;
  ResponseUpdateDentist({this.updateData});
  @override
  // TODO: implement props
  List<Object> get props => [];

  factory ResponseUpdateDentist.fromJson(dynamic jsonObject) {
    return ResponseUpdateDentist(
      updateData: UpdateData.fromJson(jsonObject['data'] ?? ''),
    );
  }
}

class UpdateData extends Equatable {
  PresentUpdate presentUpdate;
  FutureUpdate futureUpdate;

  UpdateData({this.presentUpdate, this.futureUpdate});
  @override
  // TODO: implement props
  List<Object> get props => [];

  factory UpdateData.fromJson(dynamic jsonObject) {
    return UpdateData(
      presentUpdate: PresentUpdate.fromJson(jsonObject['present'] ?? ''),
      futureUpdate: FutureUpdate.fromJson(jsonObject['future'] ?? ''),
    );
  }
}

class FutureUpdate extends Equatable {
  final String date;
  final List<Work> listWork;

  FutureUpdate({this.date, this.listWork});
  @override
  // TODO: implement props
  List<Object> get props => [date];

  factory FutureUpdate.fromJson(dynamic jsonObject) {
    var list = jsonObject['work'] as List;
    List<Work> dataWorks = list.map((i) => Work.fromJson(i)).toList();

    return FutureUpdate(
      date: jsonObject['date'] ?? '',
      listWork: dataWorks ?? '',
    );
  }
}

class PresentUpdate extends Equatable {
  final String date;
  final List<Work> listWork;
  final int count;

  PresentUpdate({this.date, this.listWork, this.count});
  @override
  // TODO: implement props
  List<Object> get props => [date];

  factory PresentUpdate.fromJson(dynamic jsonObject) {
    var list = jsonObject['work'] as List;
    List<Work> dataWorks = list.map((i) => Work.fromJson(i)).toList();

    return PresentUpdate(
      date: jsonObject['date'] ?? '',
      listWork: dataWorks ?? '',
      count: jsonObject['count'] ?? 0,
    );
  }
}

class Work extends Equatable {
  int dentistId;
  String dentistName;
  int clinicId;
  int count;
  Work({this.clinicId, this.dentistId, this.count, this.dentistName});

  factory Work.fromJson(dynamic json) {
    return Work(
      dentistId: json['dentistId'] ?? 0,
      clinicId: json['clinicId'] ?? 0,
      count: json['count'] ?? 0,
      dentistName: json['name'] ?? '',
    );
  }

  @override
  // TODO: implement props
  List<Object> get props => [dentistId];
}
