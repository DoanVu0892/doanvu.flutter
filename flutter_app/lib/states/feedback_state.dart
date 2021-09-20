import 'package:equatable/equatable.dart';
import 'package:flutter_app/models/base_response.dart';
import 'package:flutter_app/models/feedback.dart';

abstract class FeedBackState extends Equatable {
  const FeedBackState();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class FeedBackStateInitial extends FeedBackState {}

class FeedBackStateLoading extends FeedBackState {}

class FeedBackStateSuccess extends FeedBackState {
  final ResponseFeedback responseFeedback;
  FeedBackStateSuccess({this.responseFeedback});
}

class FeedBackAddStateSuccess extends FeedBackState {
  final BaseResponse responseFeedback;
  FeedBackAddStateSuccess({this.responseFeedback});
}

class FeedBackStateFailure extends FeedBackState {}

class FeedBackStateLogout extends FeedBackState {}
