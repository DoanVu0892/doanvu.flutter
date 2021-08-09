import 'package:flutter_app/events/notify_event.dart';
import 'package:flutter_app/models/notify.dart';
import 'package:flutter_app/models/utils_constant.dart';
import 'package:flutter_app/repositories/app_repository.dart';
import 'package:flutter_app/states/notify_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotifyBloc extends Bloc<NotifyEvent, NotifyState>{
  final AppRepository appRepository;
  NotifyBloc({this.appRepository}) : assert(appRepository != null), super(NotifyStateInitial());

  @override
  Stream<NotifyState> mapEventToState(NotifyEvent notifyEvent) async* {
    if(notifyEvent is NotifyManagerEventRequested){
      yield NotifyStateLoading();
      try{
        final ResponseNotify response = await new Future.delayed(const Duration(milliseconds: Constant.duration), (){
          return appRepository.getNotifyManager();
        });
        yield NotifyStateSuccess(response: response);
      }catch(e){
        print(e);
        yield NotifyStateFailure();
      }
    }else if(notifyEvent is NotifyEventRequested){
      yield NotifyStateLoading();
      try{
        final ResponseNotify response = await new Future.delayed(const Duration(milliseconds: Constant.duration), (){
          return appRepository.getNotifyCustomer('${notifyEvent.patientId}');
        });
        yield NotifyStateSuccess(response: response);
      }catch(e){
        print(e);
        yield NotifyStateFailure();
      }
    }
  }
}