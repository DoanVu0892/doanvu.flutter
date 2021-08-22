import 'package:equatable/equatable.dart';

abstract class ListWorkEvent extends Equatable {
  const ListWorkEvent();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ListWorkEventRequested extends ListWorkEvent {}
