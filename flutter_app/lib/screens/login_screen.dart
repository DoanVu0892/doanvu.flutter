import 'dart:math';
import 'dart:io' show Platform;

import 'package:date_format/date_format.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/blocs/clinic_bloc.dart';
import 'package:flutter_app/blocs/dentist_bloc.dart';
import 'package:flutter_app/blocs/login_bloc.dart';
import 'package:flutter_app/blocs/platform_bloc.dart';
import 'package:flutter_app/blocs/schedule_bloc.dart';
import 'package:flutter_app/customs/custom_circular_progress.dart';
import 'package:flutter_app/customs/pushNotification.dart';
import 'package:flutter_app/customs/snackbar.dart';
import 'package:flutter_app/customs/themes.dart';
import 'package:flutter_app/events/clinic_event.dart';
import 'package:flutter_app/events/dentist_event.dart';
import 'package:flutter_app/events/login_event.dart';
import 'package:flutter_app/events/platform_event.dart';
import 'package:flutter_app/events/schedule_event.dart';
import 'package:flutter_app/models/user.dart';
import 'package:flutter_app/repositories/app_repository.dart';
import 'package:flutter_app/screens/customer_view/book_view.dart';
import 'package:flutter_app/screens/customer_view/main_customer.dart';
import 'package:flutter_app/screens/manager_view/main_screen.dart';
import 'package:flutter_app/states/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  final AppRepository appRepository;
  final String tokenDevice;

  LoginScreen({@required this.appRepository, this.tokenDevice}) : assert(appRepository != null);

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  bool pushed = false;
  AnimationController _controller;
  Animation _animation;
  final FocusNode myFocusNodePhoneLogin = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();

  TextEditingController loginPhoneController = new TextEditingController();
  TextEditingController loginPasswordController = new TextEditingController();

  bool _obscureTextPassword = true;
  User user;
  String platform = "os";

  @override
  void dispose() {
    myFocusNodePhoneLogin.dispose();
    myFocusNodePasswordLogin.dispose();
    // WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid) {
      setState(() {
        platform = 'android';
      });
    } else if (Platform.isIOS) {
      setState(() {
        platform = 'iOS';
      });
    }
    print("platform: $platform");

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("onMessage: ${message.messageId}");
      setState(() {
        pushed = true;
      });
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print(
          "onMessageOpenedApp: ${message.notification} ");
      setState(() {
        pushed = true;
      });
    });
    //
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animation = Tween(begin: 30.0, end: 0.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    print(_animation.value);

    myFocusNodePhoneLogin.addListener(() {
      if (myFocusNodePhoneLogin.hasFocus) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });

    myFocusNodePasswordLogin.addListener(() {
      if (myFocusNodePasswordLogin.hasFocus) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewLogin = Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: <Color>[
              CustomTheme.loginGradientStart,
              CustomTheme.loginGradientEnd
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 1.0),
            stops: <double>[0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      // margin: EdgeInsets.only(top: _animation.value),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: _animation.value),
          Padding(
            padding: EdgeInsets.only(top: _animation.value + 30),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image(
                  height:
                      MediaQuery.of(context).size.height > 800 ? 191.0 : 150,
                  fit: BoxFit.fill,
                  image: const AssetImage('assets/images/nhakhoa.jpeg')),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  width: 300.0,
                  height: 190.0,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: myFocusNodePhoneLogin,
                          controller: loginPhoneController,
                          keyboardType: TextInputType.phone,
                          style: const TextStyle(
                              fontFamily: 'WorkSansSemiBold',
                              fontSize: 20.0,
                              color: Colors.black),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.phone,
                              color: Colors.black,
                              size: 22.0,
                            ),
                            hintText: 'Nhập số điện thoại',
                            hintStyle: TextStyle(
                                fontFamily: 'WorkSansSemiBold', fontSize: 17.0),
                          ),
                          onSubmitted: (_) {
                            myFocusNodePasswordLogin.requestFocus();
                          },
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: myFocusNodePasswordLogin,
                          controller: loginPasswordController,
                          obscureText: _obscureTextPassword,
                          style: const TextStyle(
                              fontFamily: 'WorkSansSemiBold',
                              fontSize: 20.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: const Icon(
                              FontAwesomeIcons.lock,
                              size: 22.0,
                              color: Colors.black,
                            ),
                            hintText: 'Nhập mật khẩu',
                            hintStyle: const TextStyle(
                                fontFamily: 'WorkSansSemiBold', fontSize: 17.0),
                            suffixIcon: GestureDetector(
                              onTap: _toggleLogin,
                              child: Icon(
                                _obscureTextPassword
                                    ? FontAwesomeIcons.eye
                                    : FontAwesomeIcons.eyeSlash,
                                size: 15.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          onSubmitted: (_) {
                            _toggleSignInButton();
                          },
                          textInputAction: TextInputAction.go,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 170.0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: CustomTheme.loginGradientStart,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                    BoxShadow(
                      color: CustomTheme.loginGradientEnd,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                  ],
                  gradient: LinearGradient(
                      colors: <Color>[
                        CustomTheme.loginGradientEnd,
                        CustomTheme.loginGradientStart
                      ],
                      begin: FractionalOffset(0.2, 0.2),
                      end: FractionalOffset(1.0, 1.0),
                      stops: <double>[0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                child: MaterialButton(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
                    child: Text(
                      'Đăng nhập',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          fontFamily: 'WorkSansBold'),
                    ),
                  ),
                  onPressed: _toggleSignInButton,
                ),
              )
            ],
          ),
        ],
      ),
    );

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: <Color>[
                  CustomTheme.loginGradientStart,
                  CustomTheme.loginGradientEnd
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 1.0),
                stops: <double>[0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: BlocConsumer<LoginBloc, LoginState>(
                listener: (context, loginState) async {
                  if (loginState is LoginStateSuccess) {
                    //checkUser
                    setState(() {
                      user = loginState.response.data.user;
                    });

                    if(user != null){
                     // BlocProvider.of<PlatformBloc>(context).add(
                     //    PlatformEventRequested(token: widget.tokenDevice, patientId: user.id)
                     //  );
                     final response = await widget.appRepository.sendDeviceToken(widget.tokenDevice, '${user.id}');
                     print("check: ${response.statusCode}");
                    }

                    if (loginState.response.data.user.userType == 'manager') {
                      BlocProvider.of<DentistBloc>(context)
                          .add(DentistEventRequested());
                    } else {
                      // DateTime selectedDate = DateTime.now();
                      // final appointmentDate =
                      //     formatDate(selectedDate, [yyyy, '-', mm, '-', dd]);
                      // BlocProvider.of<ScheduleBloc>(context).add(
                      //     ScheduleEventRequested(
                      //         dentistId:
                      //             loginState.response.data.user.dentistId,
                      //         appointmentDate: appointmentDate,
                      //         workShift: '1'));
                    }
                    Navigator.push(
                        context, _createRoute(loginState.response.data.user));
                  }
                  if (loginState is LoginStateFailure) {
                    _showSnackBar("Đăng nhập bị lỗi !!!", false);
                  }
                },
                builder: (context, loginState) {
                  if (loginState is LoginStateLoading) {
                    return CircularProgress();
                    // return CircularProgressIndicator(value: 10,);
                  }

                  if (loginState is LoginStateFailure) {
                    return viewLogin;
                  }
                  return viewLogin;
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Route _createRoute(User _user) {
    if (_user.userType == 'customer') {
      if (_user != null) {
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              MainCustomerScreen(
            user: _user,
            appRepository: widget.appRepository,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return child;
          },
        );
      } else {
        _showSnackBar('không lấy được thông tin chi nhánh | nha sỹ', false);
        return null;
      }
    } else if (_user.userType == 'manager') {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => MainScreen(
          appRepository: widget.appRepository,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return child;
        },
      );
    } else {
      _showSnackBar('sai định dạng người dùng: ${_user.userType}', false);
      return null;
    }
  }

  void _showSnackBar(String msg, bool success) {
    CustomSnackBar(
        context,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              success ? Icons.done : Icons.warning_amber_outlined,
              color: success ? Colors.green : Colors.red,
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              msg,
              style: TextStyle(
                  color: success ? Colors.green : Colors.red, fontSize: 18),
            )
          ],
        ));
  }

  void _toggleSignInButton() {
    if (loginPhoneController.text == null ||
        loginPhoneController.text.isEmpty ||
        loginPasswordController.text == null ||
        loginPasswordController.text.isEmpty) {
      _showSnackBar("Vui lòng điền đầy đủ thông tin", false);
      return;
    }
    BlocProvider.of<LoginBloc>(context).add(LoginEventRequested(
        phoneNumber: loginPhoneController.text,
        pwd: loginPasswordController.text));
  }

  void _toggleLogin() {
    setState(() {
      _obscureTextPassword = !_obscureTextPassword;
    });
  }
}
