import 'package:equatable/equatable.dart';
import 'package:flutter_app/models/history_response.dart';

abstract class HistoryState extends Equatable{
  const HistoryState();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class HistoryStateInitial extends HistoryState{}
class HistoryStateLoading extends HistoryState{}
class HistoryStateFailure extends HistoryState{}
class HistoryStateSuccess extends HistoryState{
  final HistoryResponse response;
  HistoryStateSuccess({this.response}) : assert(response != null);
  @override
  // TODO: implement props
  List<Object> get props => [response];
}