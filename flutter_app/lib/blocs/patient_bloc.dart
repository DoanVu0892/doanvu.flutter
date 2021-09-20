import 'package:flutter_app/events/patient_event.dart';
import 'package:flutter_app/models/patient.dart';
import 'package:flutter_app/models/utils_constant.dart';
import 'package:flutter_app/repositories/app_repository.dart';
import 'package:flutter_app/states/patient_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PatientBloc extends Bloc<PatientEvent, PatientState> {
  final AppRepository appRepository;
  PatientBloc({this.appRepository})
      : assert(appRepository != null),
        super(PatientStateInitial());

  @override
  Stream<PatientState> mapEventToState(PatientEvent PatientEvent) async* {
    if (PatientEvent is PatientEventRequested) {
      yield PatientStateLoading();
      try {
        final PatientResponse response = await new Future.delayed(
            const Duration(milliseconds: Constant.duration), () {
          return appRepository.getPatients(PatientEvent.dentistId);
        });
        yield PatientStateSuccess(response: response);
      } catch (exception) {
        print('ex: $exception');
        if (exception == 'logout')
          yield PatientStateLogout();
        else
          yield PatientStateFailure();
      }
    } else if (PatientEvent is PatientEventSearch) {
      yield PatientStateLoading();
      try {
        final PatientResponse response = await appRepository.searchPatient(
            PatientEvent.dentistId, PatientEvent.keyWord);
        yield PatientStateSuccess(response: response);
      } catch (exception) {
        print('ex: $exception');
        if (exception == 'logout')
          yield PatientStateLogout();
        else
          yield PatientStateFailure();
      }
    }
  }
}
