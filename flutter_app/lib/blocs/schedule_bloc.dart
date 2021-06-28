import 'package:flutter/cupertino.dart';
import 'package:flutter_app/events/schedule_event.dart';
import 'package:flutter_app/models/schedule.dart';
import 'package:flutter_app/models/schedule_add.dart';
import 'package:flutter_app/models/utils_constant.dart';
import 'package:flutter_app/repositories/app_repository.dart';
import 'package:flutter_app/states/schedule_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final AppRepository appRepository;

  ScheduleBloc({@required this.appRepository})
      : assert(appRepository != null),
        super(ScheduleStateInitial());

  @override
  Stream<ScheduleState> mapEventToState(ScheduleEvent scheduleEvent) async* {
    if (scheduleEvent is ScheduleEventRequested) {
      yield ScheduleStateLoading();
      try {
        final ScheduleResponse response = await new Future.delayed(const Duration(milliseconds: Constant.duration), (){
          return appRepository.getScheduleList(
              scheduleEvent.dentistId, scheduleEvent.appointmentDate,
              scheduleEvent.workShift);
        });
        yield ScheduleStateSuccess(response: response);
      } catch (exception) {
        print('ex: $exception');
        yield ScheduleStateFailure();
      }
    }else if (scheduleEvent is ScheduleAddEventRequested) {
      yield ScheduleStateLoading();
      try {
        final ScheduleAddResponse response =
        await appRepository.addScheduleList(
            scheduleEvent.patientId,
            scheduleEvent.patientName,
            scheduleEvent.dentistId,
            scheduleEvent.appointmentDate,
            scheduleEvent.note,
            scheduleEvent.blockId);
        yield ScheduleAddStateSuccess(response: response);
      } catch (exception) {
        print('ex: $exception');
        yield ScheduleAddStateFailure();
      }
    }else if(scheduleEvent is ScheduleDelEventRequested){
      yield ScheduleStateLoading();
      try{
        final ScheduleDelResponse response = await new Future.delayed(const Duration(milliseconds: Constant.duration), (){
          return appRepository.cancelBook(scheduleEvent.bookedId, scheduleEvent.reason);
        });
        yield ScheduleDelStateSuccess(response: response);
      }catch(exception){
        print('ex: $exception');
        yield ScheduleDelStateFailure();
      }
    }
  }

}