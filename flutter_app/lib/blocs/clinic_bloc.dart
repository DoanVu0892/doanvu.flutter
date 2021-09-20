import 'package:flutter_app/events/clinic_event.dart';
import 'package:flutter_app/models/clinic.dart';
import 'package:flutter_app/models/utils_constant.dart';
import 'package:flutter_app/repositories/app_repository.dart';
import 'package:flutter_app/states/clinic_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClinicBloc extends Bloc<ClinicEvent, ClinicState> {
  final AppRepository appRepository;

  ClinicBloc({this.appRepository})
      : assert(appRepository != null),
        super(ClinicStateInitial());

  @override
  Stream<ClinicState> mapEventToState(ClinicEvent clinicEvent) async* {
    if (clinicEvent is ClinicEventRequested) {
      yield ClinicStateLoading();
      try {
        final ClinicResponse response = await new Future.delayed(
            const Duration(milliseconds: Constant.duration), () {
          return appRepository.getClinic();
        });
        yield ClinicStateSuccess(response: response);
      } catch (exception) {
        print('ex: $exception');
        if (exception == 'logout')
          yield ClinicStateLogout();
        else
          yield ClinicStateFailure();
      }
    } else if (clinicEvent is ClinicAddEventRequested) {
      yield ClinicStateLoading();
      try {
        final ClinicAddResponse response =
            await Future.delayed(Duration(milliseconds: Constant.duration), () {
          return appRepository.addClinic(
              clinicEvent.name, clinicEvent.phone, clinicEvent.address);
        });
        yield ClinicAddStateSuccess(response: response);
      } catch (ex) {
        print('ex: $ex');
        if (ex == 'logout')
          yield ClinicStateLogout();
        else
          yield ClinicStateFailure();
      }
    } else if (clinicEvent is ClinicEditEventRequested) {
      yield ClinicStateLoading();
      try {
        final ClinicEditResponse response =
            await Future.delayed(Duration(milliseconds: Constant.duration), () {
          return appRepository.editClinic(clinicEvent.clinicId,
              clinicEvent.name, clinicEvent.phone, clinicEvent.address);
        });
        yield ClinicEditStateSuccess(response: response);
      } catch (ex) {
        print('ex: $ex');
        if (ex == 'logout')
          yield ClinicStateLogout();
        else
          yield ClinicStateFailure();
      }
    } else if (clinicEvent is ClinicDelEventRequested) {
      yield ClinicStateLoading();
      try {
        final ClinicEditResponse response =
            await Future.delayed(Duration(milliseconds: Constant.duration), () {
          return appRepository.delClinic(
            clinicEvent.clinicId,
          );
        });
        yield ClinicDelStateSuccess(response: response);
      } catch (ex) {
        print('ex: $ex');
        if (ex == 'logout')
          yield ClinicStateLogout();
        else
          yield ClinicStateFailure();
      }
    }
  }
}
