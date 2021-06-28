import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_app/events/login_event.dart';
import 'package:flutter_app/models/user.dart';
import 'package:flutter_app/models/utils_constant.dart';
import 'package:flutter_app/repositories/app_repository.dart';
import 'package:flutter_app/states/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState>{
  final AppRepository appRepository;

  LoginBloc({@required this.appRepository}) : assert(appRepository != null), super(LoginStateInitial());
  @override
  Stream<LoginState> mapEventToState(LoginEvent loginEvent) async* {
    if(loginEvent is LoginEventRequested){
      yield LoginStateLoading();
      try{
        final Response response = await new Future.delayed(const Duration(milliseconds: Constant.duration), (){
          return appRepository.login(loginEvent.phoneNumber, loginEvent.pwd);
        });
        yield LoginStateSuccess(response: response);
      }catch(exception){
        print('ex $exception');
        yield LoginStateFailure();
      }
    }
  }
}