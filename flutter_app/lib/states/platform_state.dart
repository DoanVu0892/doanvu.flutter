import 'package:equatable/equatable.dart';

abstract class PlatformState extends Equatable {
  const PlatformState();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class PlatformStateInitial extends PlatformState {}

class PlatformStateLoading extends PlatformState {}

class PlatformStateSuccess extends PlatformState {}

class PlatformStateFailure extends PlatformState {}

class PlatformStateLogout extends PlatformState {}
