
import 'package:flutter_app/custom_navigation_drawer.dart';
import 'package:flutter_app/events/update_view_event.dart';
import 'package:flutter_app/states/update_view_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateViewBloc extends Bloc<UpdateViewEvent, UpdateViewState>{
  UpdateViewBloc() : super(UpdateViewStateChanged(title: navigationItems.first.title));

  @override
  Stream<UpdateViewState> mapEventToState(UpdateViewEvent updateViewEvent) async* {
    if(updateViewEvent is UpdateViewChangedEvent){
      yield UpdateViewStateChanged(title: updateViewEvent.title);
    }
  }
}