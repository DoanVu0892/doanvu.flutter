import 'package:equatable/equatable.dart';
import 'package:flutter_app/models/base_response.dart';

class FeedBack extends Equatable {
  final String id;
  final int patientId;
  final String patientName;
  final String title;
  final String content;
  final String date;
  final String time;

  const FeedBack(
      {this.id,
      this.patientId,
      this.patientName,
      this.title,
      this.content,
      this.date,
      this.time});

  @override
  // TODO: implement props
  List<Object> get props => [id];

  factory FeedBack.fromJson(dynamic jsonObject) {
    return FeedBack(
      id: jsonObject["_id"] ?? '',
      patientId: jsonObject['patientId'] ?? 0,
      patientName: jsonObject['patientName'] ?? '',
      title: jsonObject['title'] ?? '',
      content: jsonObject['content'] ?? '',
      date: jsonObject['date'] ?? '',
      time: jsonObject['time'] ?? '',
    );
  }
}

class ResponseFeedback extends BaseResponse {
  final List<FeedBack> feedBacks;
  const ResponseFeedback({this.feedBacks});
  @override
  // TODO: implement props
  List<Object> get props => [feedBacks];

  factory ResponseFeedback.fromJson(dynamic jsonObject) {
    var list = jsonObject['data'] as List;
    List<FeedBack> datas = list.map((i) => FeedBack.fromJson(i)).toList();

    return ResponseFeedback(feedBacks: datas);
  }
}
