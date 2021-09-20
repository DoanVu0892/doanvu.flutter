import 'package:flutter_app/events/feedback_event.dart';
import 'package:flutter_app/models/base_response.dart';
import 'package:flutter_app/models/feedback.dart';
import 'package:flutter_app/models/utils_constant.dart';
import 'package:flutter_app/repositories/app_repository.dart';
import 'package:flutter_app/states/feedback_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedBackBloc extends Bloc<FeedbackEvent, FeedBackState> {
  final AppRepository appRepository;
  FeedBackBloc({this.appRepository})
      : assert(appRepository != null),
        super(FeedBackStateInitial());
  @override
  Stream<FeedBackState> mapEventToState(FeedbackEvent feedbackEvent) async* {
    if (feedbackEvent is FeedbackEventRequested) {
      yield FeedBackStateLoading();
      try {
        final ResponseFeedback response = await new Future.delayed(
            const Duration(milliseconds: Constant.duration), () {
          return appRepository.getFeedBack();
        });
        yield FeedBackStateSuccess(responseFeedback: response);
      } catch (e) {
        print(e);
        if (e == 'logout') {
          yield FeedBackStateLogout();
        } else {
          yield FeedBackStateFailure();
        }
      }
    } else if (feedbackEvent is FeedbackAddEventRequested) {
      yield FeedBackStateLoading();
      try {
        final BaseResponse response = await new Future.delayed(
            const Duration(milliseconds: Constant.duration), () {
          return appRepository.sendFeedback(
              '${feedbackEvent.patientId}',
              '${feedbackEvent.patientName}',
              '${feedbackEvent.title}',
              '${feedbackEvent.content}');
        });
        yield FeedBackAddStateSuccess(responseFeedback: response);
      } catch (e) {
        print(e);
        if (e == 'logout') {
          yield FeedBackStateLogout();
        } else {
          yield FeedBackStateFailure();
        }
      }
    }
  }
}
