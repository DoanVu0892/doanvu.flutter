import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class BranchEvent extends Equatable{
  const BranchEvent();
}

class BranchEventRequested extends BranchEvent{
  final String accessToken;
  const BranchEventRequested({@required this.accessToken}) : assert(accessToken != null);
  @override
  // TODO: implement props
  List<Object> get props => [accessToken];
}

class BranchEventRequestedNonToken extends BranchEvent{
  const BranchEventRequestedNonToken();
  @override
  // TODO: implement props
  List<Object> get props => [];
}