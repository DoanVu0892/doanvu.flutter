import 'package:flutter_app/events/leave_schedule_event.dart';
import 'package:flutter_app/models/leave_schedule.dart';
import 'package:flutter_app/models/utils_constant.dart';
import 'package:flutter_app/repositories/app_repository.dart';
import 'package:flutter_app/states/leave_schedule_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LeaveScheduleBloc extends Bloc<LeaveScheduleEvent, LeaveScheduleState>{
  final AppRepository appRepository;
  LeaveScheduleBloc({this.appRepository}) : assert(appRepository != null), super(LeaveScheduleInitial());

  @override
  Stream<LeaveScheduleState> mapEventToState(LeaveScheduleEvent leaveScheduleEvent) async* {
    if(leaveScheduleEvent is LeaveScheduleEventRequested){
      yield LeaveScheduleLoading();
      try{
        final ResLeaveSchedule response = await new Future.delayed(const Duration(milliseconds: Constant.duration), (){
          return appRepository.setLeaveSchedule(leaveScheduleEvent.dentistId, leaveScheduleEvent.startDate, leaveScheduleEvent.endDate, leaveScheduleEvent.shiftWork, leaveScheduleEvent.reason);
        });
        yield LeaveScheduleSuccess(response: response);
      }catch(e){
        print("ex: $e");
        yield LeaveScheduleFailure();
      }
    }
  }
}