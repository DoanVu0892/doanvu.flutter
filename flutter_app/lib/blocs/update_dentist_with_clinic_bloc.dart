import 'package:flutter_app/events/update_dentist_with_clinic_event.dart';
import 'package:flutter_app/models/base_response.dart';
import 'package:flutter_app/models/utils_constant.dart';
import 'package:flutter_app/repositories/app_repository.dart';
import 'package:flutter_app/states/update_dentist_with_clinic_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateDentistWithClinicBloc extends Bloc<UpdateDentistWithClinicEvent, UpdateDentistWithClinicState>{
  final AppRepository appRepository;
  UpdateDentistWithClinicBloc({this.appRepository}) : assert(appRepository != null), super(UpdateDentistWithClinicInitial());

  @override
  Stream<UpdateDentistWithClinicState> mapEventToState(UpdateDentistWithClinicEvent updateDentistWithClinicEvent) async* {
      if(updateDentistWithClinicEvent is UpdateDentistWithClinicEventRequested){
        yield UpdateDentistWithClinicLoading();
        try{
          final BaseResponse response = await new Future.delayed(const Duration(milliseconds: Constant.duration), (){
                return appRepository.updateDentistWithClinicId('${updateDentistWithClinicEvent.dentistId}', '${updateDentistWithClinicEvent.clinicId}');
          });
          yield UpdateDentistWithClinicSuccess(response: response);
        }catch(e){
          print(e);
          yield UpdateDentistWithClinicFailure();
        }
      }
  }
}