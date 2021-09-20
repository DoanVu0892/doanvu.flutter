import 'package:flutter_app/events/history_event.dart';
import 'package:flutter_app/models/history_response.dart';
import 'package:flutter_app/models/utils_constant.dart';
import 'package:flutter_app/repositories/app_repository.dart';
import 'package:flutter_app/states/history_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final AppRepository appRepository;
  HistoryBloc({this.appRepository})
      : assert(appRepository != null),
        super(HistoryStateInitial());

  @override
  Stream<HistoryState> mapEventToState(HistoryEvent historyEvent) async* {
    if (historyEvent is HistoryEventRequested) {
      yield HistoryStateLoading();
      try {
        final HistoryResponse response = await new Future.delayed(
            Duration(milliseconds: Constant.duration), () {
          return appRepository.getHistory(historyEvent.patientId);
        });
        yield HistoryStateSuccess(response: response);
      } catch (exception) {
        print('ex: $exception');
        if (exception == 'logout')
          yield HistoryStateLogout();
        else
          yield HistoryStateFailure();
      }
    }
  }
}
