import 'package:flutter_app/events/add_manager_event.dart';
import 'package:flutter_app/models/base_response.dart';
import 'package:flutter_app/models/utils_constant.dart';
import 'package:flutter_app/repositories/app_repository.dart';
import 'package:flutter_app/states/add_manager_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserManagerBloc extends Bloc<UserManagerEvent, UserManagerState>{
  final AppRepository appRepository;
  UserManagerBloc({this.appRepository}) : assert(appRepository != null), super(UserManagerStateInitial());

  @override
  Stream<UserManagerState> mapEventToState(UserManagerEvent userManagerEvent) async* {
    if(userManagerEvent is UserManagerEventRequested){
      yield UserManagerStateLoading();
      try{
        final BaseResponse response =
        await new Future.delayed(const Duration(milliseconds: Constant.duration), () {
          return appRepository.addUserManager(userManagerEvent.phone, userManagerEvent.password, userManagerEvent.name, '${userManagerEvent.clinicId}');
        });
        if(response.status == 'ok'){
          yield UserManagerStateSuccess();
        }else{
          yield UserManagerStateFailure();
        }
      }catch(e){
        print(e);
        yield UserManagerStateFailure();
      }
    }
  }

}