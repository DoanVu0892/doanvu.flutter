import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/blocs/clinic_bloc.dart';
import 'package:flutter_app/customs/snackbar.dart';
import 'package:flutter_app/customs/themes.dart';
import 'package:flutter_app/events/clinic_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddClinicScreen extends StatefulWidget {
  @override
  _AddClinicScreenState createState() => _AddClinicScreenState();
}

class _AddClinicScreenState extends State<AddClinicScreen> {
  final FocusNode myFocusNodeName = FocusNode();

  final FocusNode myFocusNodePhone = FocusNode();

  final FocusNode myFocusNodeAddress = FocusNode();

  TextEditingController nameController = new TextEditingController();

  TextEditingController phoneController = new TextEditingController();

  TextEditingController addressController = new TextEditingController();

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
                'Thêm chi nhánh',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          backgroundColor: CustomTheme.colorEnd,
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: const BoxDecoration(
            gradient: CustomTheme.primaryGradient,
          ),
          child: Center(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 50, bottom: 10),
                  child: Text(
                    'Nhập thông tin chi nhánh',
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
                        height: 220,
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
                                  hintText: 'Nhập tên chi nhánh',
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
                                  myFocusNodeAddress.requestFocus();
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
                                focusNode: myFocusNodeAddress,
                                controller: addressController,
                                style: const TextStyle(
                                    fontFamily: 'WorkSansSemiBold',
                                    fontSize: 16.0,
                                    color: Colors.black),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  icon: Icon(Icons.map),
                                  hintText: 'Nhập địa chỉ',
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
                      margin: const EdgeInsets.only(top: 210.0),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: CustomTheme.colorStart,
                            offset: Offset(1.0, 6.0),
                            blurRadius: 20.0,
                          ),
                          BoxShadow(
                            color: CustomTheme.colorEnd,
                            offset: Offset(1.0, 6.0),
                            blurRadius: 20.0,
                          ),
                        ],
                        gradient: CustomTheme.primaryGradient,
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
        phoneController.text.isEmpty ||
        addressController.text.isEmpty ||
        addressController.text == null) {
      _showSnackBar(context, 'Vui lòng điền đầy đủ thông tin', false);
      return;
    }

    BlocProvider.of<ClinicBloc>(context).add(ClinicAddEventRequested(
        name: nameController.text,
        phone: phoneController.text,
        address: addressController.text));
    Navigator.of(context).pop(true);
  }

  void _showSnackBar(BuildContext context, String msg, bool success) {
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
