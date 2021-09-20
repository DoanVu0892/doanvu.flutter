import 'package:equatable/equatable.dart';

abstract class FeedbackEvent extends Equatable {
  const FeedbackEvent();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class FeedbackAddEventRequested extends FeedbackEvent {
  final int patientId;
  final String patientName;
  final String title;
  final String content;

  FeedbackAddEventRequested(
      {this.patientId, this.patientName, this.title, this.content});
}

class FeedbackEventRequested extends FeedbackEvent {}
