import 'dart:convert';

import 'package:flutter_app/models/base_response.dart';

class PlatformResponse extends BaseResponse{
  final String token;
  final String patientId;

  const PlatformResponse({this.token, this.patientId});

  @override
  // TODO: implement props
  List<Object> get props => [patientId];

  factory PlatformResponse.fromJson(dynamic jsonObject){
    final data = Map<String, dynamic>.from(jsonObject['data']);
    print('data ${jsonEncode(data)}');

    return PlatformResponse(
      token: data['token'] ?? '',
      patientId: data['patientId'] ?? '',
    );
  }
}