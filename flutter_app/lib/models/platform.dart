import 'dart:convert';

import 'package:flutter_app/models/base_response.dart';

class PlatformResponse extends BaseResponse{
  final String id;
  final String token;
  final String os;
  final String patientId;

  const PlatformResponse({this.id,this.token, this.os, this.patientId});

  @override
  // TODO: implement props
  List<Object> get props => [id];

  factory PlatformResponse.fromJson(dynamic jsonObject){
    final data = Map<String, dynamic>.from(jsonObject['data']);
    print('data ${jsonEncode(data)}');

    return PlatformResponse(
      id: data['_id'] ?? '',
      token: data['token'] ?? '',
      os: data['os'] ?? '',
      patientId: data['patientId'] ?? '',
    );
  }
}