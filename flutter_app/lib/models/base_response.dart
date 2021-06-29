import 'package:equatable/equatable.dart';

class BaseResponse extends Equatable {
  final String status;
  final int statusCode;
  final String message;

  const BaseResponse({this.status, this.message, this.statusCode});

  @override
  // TODO: implement props
  List<Object> get props => [];
  factory BaseResponse.fromJson(dynamic jsonObject){
    return BaseResponse(
      status: jsonObject['status'] ?? '',
      statusCode: jsonObject['statusCode'] ?? 0,
      message: jsonObject['message'] ?? '',
    );
  }
}