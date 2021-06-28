import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/blocs/clinic_bloc.dart';
import 'package:flutter_app/blocs/login_bloc.dart';
import 'package:flutter_app/customs/custom_circular_progress.dart';
import 'package:flutter_app/customs/snackbar.dart';
import 'package:flutter_app/customs/themes.dart';
import 'package:flutter_app/events/clinic_event.dart';
import 'package:flutter_app/events/login_event.dart';
import 'package:flutter_app/screens/new/main_screen.dart';
import 'package:flutter_app/states/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin{
  AnimationController _controller;
  Animation _animation;
  final FocusNode myFocusNodePhoneLogin = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();

  TextEditingController loginPhoneController = new TextEditingController();
  TextEditingController loginPasswordController = new TextEditingController();

  bool _obscureTextPassword = true;

  @override
  void dispose() {
    myFocusNodePhoneLogin.dispose();
    myFocusNodePasswordLogin.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animation = Tween(begin: 30.0, end: 0.0).animate(_controller)..addListener(() {
      setState(() {});
    });

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
      padding: EdgeInsets.only(top: _animation.value),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: _animation.value),
          Padding(
            padding: const EdgeInsets.only(top: 75.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image(
                  height: MediaQuery.of(context).size.height > 800 ? 191.0 : 150,
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
                              fontSize: 16.0,
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
                              fontSize: 16.0,
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

    return WillPopScope(
      onWillPop: () => showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          title: Text('Cảnh báo'),
          content: Text('Bạn có muốn thoát ứng dụng?'),
          actions: [
            // ignore: deprecated_member_use
            FlatButton(
              child: Text('Đồng ý'),
              onPressed: () => Navigator.pop(c, true),
            ),
            // ignore: deprecated_member_use
            FlatButton(
              child: Text('Không'),
              onPressed: () => Navigator.pop(c, false),
            ),
          ],
        ),
      ),
      child: GestureDetector(
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
                  listener: (context, loginState) {
                    if (loginState is LoginStateSuccess) {
                      //checkUser
                      if(loginState.response.data.user.userType == 'manager'){
                        BlocProvider.of<ClinicBloc>(context)
                            .add(ClinicEventRequested());
                      }else{
                        print('chưa code');
                      }
                      Navigator.push(
                          context,_createRoute(loginState.response.data.user.userType));
                    }
                    if (loginState is LoginStateFailure) {
                      _showSnackBar("'Đăng nhập bị lỗi!!!'", false);
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
      ),
    );
  }

  Route _createRoute(String userType) {
    if(userType == 'customer'){
      return null;
    }else if(userType == 'manager'){
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => MainScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return child;
        },
      );
    }else{
      _showSnackBar('sai định dạng người dùng: $userType', false);
      return null;
    }
  }
  void _showSnackBar(String msg, bool success) {
    CustomSnackBar(
        context,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(success ? Icons.done : Icons.warning_amber_outlined, color: success ? Colors.green : Colors.red,),
            SizedBox(
              width: 20,
            ),
            Text(
              msg,
              style: TextStyle(color: success ? Colors.green : Colors.red, fontSize: 18),
            )
          ],
        ));
  }

  void _toggleSignInButton() {
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
