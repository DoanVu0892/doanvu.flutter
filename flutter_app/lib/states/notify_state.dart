import 'package:equatable/equatable.dart';
import 'package:flutter_app/models/notify.dart';

abstract class NotifyState extends Equatable{
  const NotifyState();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class NotifyStateInitial extends NotifyState{}
class NotifyStateSuccess extends NotifyState{
  final ResponseNotify response;
  const NotifyStateSuccess({this.response});
  @override
  // TODO: implement props
  List<Object> get props => [response];
}
class NotifyStateLoading extends NotifyState{}
class NotifyStateFailure extends NotifyState{}