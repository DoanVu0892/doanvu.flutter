import 'dart:async';
import 'dart:math';

import 'package:flutter_app/events/dentist_event.dart';
import 'package:flutter_app/models/base_response.dart';
import 'package:flutter_app/models/dentist.dart';
import 'package:flutter_app/models/utils_constant.dart';
import 'package:flutter_app/repositories/app_repository.dart';
import 'package:flutter_app/states/dentist_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DentistBloc extends Bloc<DentistEvent, DentistState> {
  final AppRepository appRepository;

  DentistBloc({this.appRepository})
      : assert(appRepository != null),
        super(DentistStateInitial());

  @override
  Stream<DentistState> mapEventToState(DentistEvent dentistEvent) async* {
    if (dentistEvent is DentistEventRequested) {
      yield DentistStateLoading();
      try {
        final DentistResponse response = await new Future.delayed(
            const Duration(milliseconds: Constant.duration), () {
          return appRepository.getDentist();
        });
        yield DentistStateSuccess(response: response);
      } catch (exception) {
        print('ex: $exception');
        if (exception == 'logout')
          yield DentistStateLogout();
        else
          yield DentistStateFailure();
      }
    } else if (dentistEvent is DentistAddEventRequested) {
      yield DentistStateLoading();
      try {
        final BaseResponse response = await new Future.delayed(
            Duration(milliseconds: Constant.duration), () {
          return appRepository.addDentist(
              dentistEvent.clinicId, dentistEvent.name, dentistEvent.phone);
        });
        yield DentistAddStateSuccess(response: response);
      } catch (ex) {
        print('ex: $ex');
        if (ex == 'logout')
          yield DentistStateLogout();
        else
          yield DentistStateFailure();
      }
    } else if (dentistEvent is DentistEditEventRequested) {
      yield DentistStateLoading();
      try {
        final BaseResponse response = await new Future.delayed(
            Duration(milliseconds: Constant.duration), () {
          return appRepository.editDentist(
              dentistEvent.dentistId, dentistEvent.name, dentistEvent.phone);
        });
        yield DentistEditStateSuccess(response: response);
      } catch (ex) {
        print('ex: $ex');
        if (ex == 'logout')
          yield DentistStateLogout();
        else
          yield DentistStateFailure();
      }
    } else if (dentistEvent is DentistDelEventRequested) {
      yield DentistStateLoading();
      try {
        final BaseResponse response = await new Future.delayed(
            Duration(milliseconds: Constant.duration), () {
          return appRepository.delDentist(dentistEvent.dentistId);
        });
        yield DentistDelStateSuccess(response: response);
      } catch (ex) {
        print('ex: $ex');
        if (ex == 'logout')
          yield DentistStateLogout();
        else
          yield DentistStateFailure();
      }
    }
  }
}
