import 'package:flutter/material.dart';
import 'package:flutter_app/blocs/bloc_observer.dart';
import 'package:flutter_app/blocs/clinic_bloc.dart';
import 'package:flutter_app/blocs/dentist_bloc.dart';
import 'package:flutter_app/blocs/history_bloc.dart';
import 'package:flutter_app/blocs/login_bloc.dart';
import 'package:flutter_app/blocs/patient_bloc.dart';
import 'package:flutter_app/blocs/schedule_bloc.dart';
import 'package:flutter_app/blocs/update_view_bloc.dart';
import 'package:flutter_app/repositories/app_repository.dart';
import 'package:flutter_app/screens/login_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

void main(){
  Bloc.observer = AppBlocObserver();
  final AppRepository appRepository =  AppRepository(httpClient: http.Client());

  runApp(
    MultiBlocProvider(providers: [
      BlocProvider<UpdateViewBloc>(create: (context) => UpdateViewBloc()),
      BlocProvider<LoginBloc>(create: (context) => LoginBloc(appRepository: appRepository)),
      BlocProvider<ScheduleBloc>(create: (context) => ScheduleBloc(appRepository: appRepository)),
      BlocProvider<PatientBloc>(create: (context) => PatientBloc(appRepository: appRepository)),
      BlocProvider<HistoryBloc>(create: (context) => HistoryBloc(appRepository: appRepository)),
      BlocProvider<ClinicBloc>(create: (context) => ClinicBloc(appRepository: appRepository)),
      BlocProvider<DentistBloc>(create: (context) => DentistBloc(appRepository: appRepository)),
    ], child: MyApp(appRepository: appRepository,))
  );
}

class MyApp extends StatelessWidget{
  final AppRepository appRepository;
  MyApp({ Key key, @required this.appRepository}) : assert(appRepository != null), super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Dential',
      home: BlocProvider(
        create: (context) => LoginBloc(appRepository: appRepository),
        child: LoginScreen(),
      ),
    );
  }
}