import 'package:equatable/equatable.dart';
import 'package:flutter_app/models/dentist_update.dart';

abstract class ListWorkState extends Equatable {
  const ListWorkState();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ListWorkStateInitial extends ListWorkState {}

class ListWorkStateLoading extends ListWorkState {}

class ListWorkStateSuccess extends ListWorkState {
  final ResponseUpdateDentist response;
  ListWorkStateSuccess(this.response);
}

class ListWorkStateLogout extends ListWorkState {}

class ListWorkStateFailure extends ListWorkState {}
