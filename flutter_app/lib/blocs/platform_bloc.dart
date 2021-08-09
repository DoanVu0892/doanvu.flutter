import 'package:flutter_app/events/platform_event.dart';
import 'package:flutter_app/models/utils_constant.dart';
import 'package:flutter_app/repositories/app_repository.dart';
import 'package:flutter_app/states/platform_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlatformBloc extends Bloc<PlatformEvent, PlatformState>{
  final AppRepository appRepository;
  PlatformBloc({this.appRepository}) : assert(appRepository != null), super(PlatformStateInitial());

  @override
  Stream<PlatformState> mapEventToState(PlatformEvent platformEvent) async* {
    if(platformEvent is PlatformEventRequested){
      // yield PlatformStateLoading();
      try{
        final response = await new Future.delayed(const Duration(milliseconds: Constant.duration), (){
          return appRepository.sendDeviceToken(platformEvent.token, '${platformEvent.patientId}');
        });
        print('responseSendDeviceToken: ${response.statusCode}');
        if(response.statusCode == 200){
          yield PlatformStateSuccess();
        }else yield PlatformStateFailure();
      }catch(e){
        print('ex: $e');
        yield PlatformStateFailure();
      }
    }
  }
}