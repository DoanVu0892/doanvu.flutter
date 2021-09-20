import 'package:flutter_app/events/list_work_event.dart';
import 'package:flutter_app/models/dentist_update.dart';
import 'package:flutter_app/models/utils_constant.dart';
import 'package:flutter_app/repositories/app_repository.dart';
import 'package:flutter_app/states/list_work_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListWorkBloc extends Bloc<ListWorkEvent, ListWorkState> {
  final AppRepository appRepository;

  ListWorkBloc({this.appRepository})
      : assert(appRepository != null),
        super(ListWorkStateInitial());

  @override
  Stream<ListWorkState> mapEventToState(ListWorkEvent listWorkEvent) async* {
    if (listWorkEvent is ListWorkEventRequested) {
      yield ListWorkStateLoading();
      try {
        final ResponseUpdateDentist response = await new Future.delayed(
            const Duration(milliseconds: Constant.duration), () {
          return appRepository.getListWork();
        });
        yield ListWorkStateSuccess(response);
      } catch (e) {
        print(e);
        if (e == 'logout')
          yield ListWorkStateLogout();
        else
          yield ListWorkStateFailure();
      }
    }
  }
}
