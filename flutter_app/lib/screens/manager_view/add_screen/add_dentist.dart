import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/blocs/dentist_bloc.dart';
import 'package:flutter_app/customs/snackbar.dart';
import 'package:flutter_app/customs/themes.dart';
import 'package:flutter_app/events/dentist_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddDentistScreen extends StatefulWidget {
  final String clinicId;

  AddDentistScreen({this.clinicId});

  @override
  _AddDentistScreenState createState() => _AddDentistScreenState();
}

class _AddDentistScreenState extends State<AddDentistScreen> {
  final FocusNode myFocusNodeName = FocusNode();

  final FocusNode myFocusNodePhone = FocusNode();

  TextEditingController nameController = new TextEditingController();

  TextEditingController phoneController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: Container(
            margin: EdgeInsets.only(left: 10),
            child: InkWell(
              onTap: () async {
                Navigator.pop(context, false);
              },
              child: Container(
                  width: 60,
                  height: 30,
                  child: Center(child: Icon(Icons.arrow_back_ios))),
            ),
          ),
          title: Center(
            child: Container(
              margin: EdgeInsets.only(right: 40),
              child: Text(
                'Thêm nha sỹ',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          backgroundColor: CustomTheme.loginGradientStart,
        ),
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
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 50, bottom: 10),
                  child: Text(
                    'Nhập thông tin nha sỹ',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
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
                        height: 150,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0,
                                  bottom: 10.0,
                                  left: 25.0,
                                  right: 25.0),
                              child: TextField(
                                focusNode: myFocusNodeName,
                                controller: nameController,
                                style: const TextStyle(
                                    fontFamily: 'WorkSansSemiBold',
                                    fontSize: 16.0,
                                    color: Colors.black),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  icon: Icon(Icons.home),
                                  hintText: 'Nhập tên',
                                  hintStyle: TextStyle(
                                      fontFamily: 'WorkSansSemiBold',
                                      fontSize: 17.0),
                                ),
                                onSubmitted: (_) {
                                  myFocusNodePhone.requestFocus();
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
                                  top: 10.0,
                                  bottom: 10.0,
                                  left: 25.0,
                                  right: 25.0),
                              child: TextField(
                                focusNode: myFocusNodePhone,
                                controller: phoneController,
                                keyboardType: TextInputType.phone,
                                style: const TextStyle(
                                    fontFamily: 'WorkSansSemiBold',
                                    fontSize: 16.0,
                                    color: Colors.black),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  icon: Icon(Icons.phone_android),
                                  hintText: 'Nhập số điện thoại',
                                  hintStyle: const TextStyle(
                                      fontFamily: 'WorkSansSemiBold',
                                      fontSize: 17.0),
                                ),
                                onSubmitted: (_) {
                                  _toggleAddClinicButton(context);
                                },
                                textInputAction: TextInputAction.go,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 140.0),
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
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 42.0),
                          child: Text(
                            'Thêm',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25.0,
                                fontFamily: 'WorkSansBold'),
                          ),
                        ),
                        onPressed: () {
                          _toggleAddClinicButton(context);
                        },
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _toggleAddClinicButton(BuildContext context) {
    if (nameController.text == null ||
        nameController.text.isEmpty ||
        phoneController.text == null ||
        phoneController.text.isEmpty) {
      _showSnackBar('Vui lòng điền đầy đủ thông tin', false);
      return;
    }

    BlocProvider.of<DentistBloc>(context).add(DentistAddEventRequested(
      clinicId: widget.clinicId,
      name: nameController.text,
      phone: phoneController.text,
    ));
    Navigator.of(context).pop(true);
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
}
