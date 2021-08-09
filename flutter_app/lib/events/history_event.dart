import 'package:equatable/equatable.dart';

abstract class HistoryEvent extends Equatable {
  const HistoryEvent();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class HistoryEventRequested extends HistoryEvent {
  final int patientId;
  const HistoryEventRequested({this.patientId}) : assert(patientId != null);
  @override
  // TODO: implement props
  List<Object> get props => [patientId];
}
