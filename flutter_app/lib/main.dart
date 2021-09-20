import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/blocs/add_manager_bloc.dart';
import 'package:flutter_app/blocs/bloc_observer.dart';
import 'package:flutter_app/blocs/clinic_bloc.dart';
import 'package:flutter_app/blocs/dentist_bloc.dart';
import 'package:flutter_app/blocs/feedback_bloc.dart';
import 'package:flutter_app/blocs/history_bloc.dart';
import 'package:flutter_app/blocs/leave_schedule_bloc.dart';
import 'package:flutter_app/blocs/list_work_bloc.dart';
import 'package:flutter_app/blocs/login_bloc.dart';
import 'package:flutter_app/blocs/notify_bloc.dart';
import 'package:flutter_app/blocs/patient_bloc.dart';
import 'package:flutter_app/blocs/platform_bloc.dart';
import 'package:flutter_app/blocs/schedule_bloc.dart';
import 'package:flutter_app/blocs/update_dentist_with_clinic_bloc.dart';
import 'package:flutter_app/customs/pushNotification.dart';
import 'package:flutter_app/repositories/app_repository.dart';
import 'package:flutter_app/screens/login_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:oktoast/oktoast.dart';
import 'package:overlay_support/overlay_support.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = AppBlocObserver();
  final AppRepository appRepository = AppRepository(httpClient: http.Client());

  runApp(MultiBlocProvider(
      providers: [
        BlocProvider<LeaveScheduleBloc>(
            create: (context) =>
                LeaveScheduleBloc(appRepository: appRepository)),
        BlocProvider<FeedBackBloc>(
            create: (context) => FeedBackBloc(appRepository: appRepository)),
        BlocProvider<UpdateDentistWithClinicBloc>(
            create: (context) =>
                UpdateDentistWithClinicBloc(appRepository: appRepository)),
        BlocProvider<ListWorkBloc>(
            create: (context) => ListWorkBloc(appRepository: appRepository)),
        BlocProvider<UserManagerBloc>(
            create: (context) => UserManagerBloc(appRepository: appRepository)),
        BlocProvider<NotifyBloc>(
            create: (context) => NotifyBloc(appRepository: appRepository)),
        BlocProvider<PlatformBloc>(
            create: (context) => PlatformBloc(appRepository: appRepository)),
        BlocProvider<LoginBloc>(
            create: (context) => LoginBloc(appRepository: appRepository)),
        BlocProvider<ScheduleBloc>(
            create: (context) => ScheduleBloc(appRepository: appRepository)),
        BlocProvider<PatientBloc>(
            create: (context) => PatientBloc(appRepository: appRepository)),
        BlocProvider<HistoryBloc>(
            create: (context) => HistoryBloc(appRepository: appRepository)),
        BlocProvider<ClinicBloc>(
            create: (context) => ClinicBloc(appRepository: appRepository)),
        BlocProvider<DentistBloc>(
            create: (context) => DentistBloc(appRepository: appRepository)),
      ],
      child: MyApp(
        appRepository: appRepository,
      )));
}

class MyApp extends StatefulWidget {
  final AppRepository appRepository;

  MyApp({Key key, @required this.appRepository})
      : assert(appRepository != null),
        super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  FirebaseNotification firebase;
  bool pushed = false;
  String tokenDevice = '';

  handleAsync() async {
    await firebase.initialize();

    String token = await firebase.getToken();
    print("Firebase token : $token");
    setState(() {
      tokenDevice = token;
    });
  }

  @override
  void initState() {
    super.initState();
    firebase = FirebaseNotification();
    handleAsync();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: OKToast(
        child: MaterialApp(
          title: 'Dential',
          home: BlocProvider(
            create: (context) => LoginBloc(appRepository: widget.appRepository),
            child: LoginScreen(
              appRepository: widget.appRepository,
              tokenDevice: tokenDevice,
            ),
          ),
          routes: {
            "/login": (BuildContext context) => new LoginScreen(
                  appRepository: widget.appRepository,
                  tokenDevice: tokenDevice,
                ),
          },
        ),
      ),
    );
  }
}
