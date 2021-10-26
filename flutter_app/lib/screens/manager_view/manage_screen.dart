import 'package:flutter/material.dart';
import 'package:flutter_app/blocs/add_manager_bloc.dart';
import 'package:flutter_app/blocs/clinic_bloc.dart';
import 'package:flutter_app/blocs/dentist_bloc.dart';
import 'package:flutter_app/customs/custom_circular_progress.dart';
import 'package:flutter_app/customs/snackbar.dart';
import 'package:flutter_app/customs/themes.dart';
import 'package:flutter_app/customs/utils.dart';
import 'package:flutter_app/events/add_manager_event.dart';
import 'package:flutter_app/events/clinic_event.dart';
import 'package:flutter_app/events/dentist_event.dart';
import 'package:flutter_app/models/clinic.dart';
import 'package:flutter_app/screens/manager_view/add_screen/add_clinic.dart';
import 'package:flutter_app/screens/manager_view/dentist_screen.dart';
import 'package:flutter_app/states/add_manager_state.dart';
import 'package:flutter_app/states/clinic_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ManageScreen extends StatefulWidget {
  @override
  _ManageScreenState createState() => _ManageScreenState();
}

class _ManageScreenState extends State<ManageScreen> {
  List<Clinic> clinicList = [];
  bool shouldUpdate = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  TextEditingController phoneNController = TextEditingController();
  TextEditingController passWordController = TextEditingController();
  TextEditingController managerNameController = TextEditingController();

  FocusNode phoneNFocus = FocusNode();
  FocusNode passFocus = FocusNode();
  FocusNode nameNFocus = FocusNode();

  FocusNode nameFocus = FocusNode();
  FocusNode phoneFocus = FocusNode();
  FocusNode addressFocus = FocusNode();

  bool _obscureTextPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Container(
          margin: EdgeInsets.only(left: 10),
          child: InkWell(
            onTap: () async {
              Navigator.pop(context, true);
            },
            child: Container(
                width: 60,
                height: 30,
                child: Center(child: Icon(Icons.arrow_back_ios))),
          ),
        ),
        backgroundColor: CustomTheme.colorEnd,
        title: Center(
          child: Container(
            margin: EdgeInsets.only(right: 50),
            child: Text(
              'Thêm mới Quản lý',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(bottom: 20),
        decoration: const BoxDecoration(
          gradient: CustomTheme.primaryGradient,
        ),
        child: BlocConsumer<ClinicBloc, ClinicState>(
          listener: (context, state) {
            if (state is ClinicStateSuccess) {
              setState(() {
                clinicList = state.response.dataList;
              });
              print('clinic: ${clinicList.first.name}');
              if (shouldUpdate) {
                setState(() {
                  shouldUpdate = false;
                });
                _showSnackBar('Thêm chi nhánh thành công', true);
              }
            } else if (state is ClinicEditStateSuccess) {
              BlocProvider.of<ClinicBloc>(context).add(
                ClinicEventRequested(),
              );
              _showSnackBar('Sửa chi nhánh thành công', true);
            } else if (state is ClinicDelStateSuccess) {
              BlocProvider.of<ClinicBloc>(context).add(
                ClinicEventRequested(),
              );
              _showSnackBar('Xóa chi nhánh thành công', true);
            }
            if (state is ClinicStateLogout) {
              // Navigator.popAndPushNamed(context, '/login');
              Utils.gotoLogin(context);
            }
          },
          builder: (context, state) {
            if (state is ClinicStateLoading) {
              return CircularProgress();
            }

            if (state is ClinicStateFailure) {
              _showSnackBar('Không có dữ liệu', false);
            }

            if (state is ClinicStateSuccess ||
                state is ClinicEditStateSuccess ||
                state is ClinicDelStateSuccess) {
              return Column(
                children: <Widget>[
                  BlocConsumer<UserManagerBloc, UserManagerState>(
                    listener: (context, state) {
                      if (state is UserManagerStateSuccess) {
                        _showSnackBar("Thêm thành công", true);
                      }
                      if (state is UserManagerStateFailure) {
                        _showSnackBar("Thêm không thành công", false);
                      }
                      if (state is UserManagerStateLogout) {
                        // Navigator.popAndPushNamed(context, '/login');
                        Utils.gotoLogin(context);
                      }
                    },
                    builder: (context, state) {
                      if (state is UserManagerStateLoading) {
                        return Container(
                            margin: EdgeInsets.only(top: 20),
                            child: CircularProgress());
                      }
                      return Text('');
                    },
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Text(
                          'Chọn chi nhánh',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: ListView.builder(
                      physics: ScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: clinicList.length,
                      itemBuilder: (context, index) {
                        final clinic = clinicList[index];
                        return Card(
                          child: ListTile(
                            leading: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: CustomTheme.colorEnd),
                                child: Icon(
                                  Icons.home,
                                  color: Colors.white,
                                )),
                            title: Text(clinic.name),
                            subtitle: Text(clinic.address),
                            onTap: () {
                              // BlocProvider.of<DentistBloc>(context)
                              //     .add(DentistEventRequested());
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             DentistScreen(clinicId: clinic.id)));
                              //edit 08-08
                              print('clinicId: ${clinic.id}');
                              DialogUtils.showCustomDialog(context,
                                  title: 'Nhập thông tin',
                                  child: GestureDetector(
                                    onTap: () {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                    },
                                    child: Container(
                                      height: 300,
                                      width: 300,
                                      padding: EdgeInsets.all(5),
                                      child: Column(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              child: Column(
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        bottom: 4),
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      'Số điện thoại',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18),
                                                    ),
                                                  ),
                                                  TextField(
                                                    maxLines: 1,
                                                    decoration: InputDecoration(
                                                      hintText: 'Số điện thoại',
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelStyle: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    controller:
                                                        phoneNController,
                                                    keyboardType:
                                                        TextInputType.phone,
                                                    focusNode: phoneNFocus,
                                                    onSubmitted: (_) {
                                                      passFocus.requestFocus();
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              child: Column(
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        bottom: 5, top: 4),
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      'Mật khẩu',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18),
                                                    ),
                                                  ),
                                                  TextField(
                                                    maxLines: 1,
                                                    // obscureText: _obscureTextPassword,
                                                    decoration: InputDecoration(
                                                      hintText: "Mật khẩu",
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelStyle: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      // suffixIcon: GestureDetector(
                                                      //   onTap: (){
                                                      //     print('onTap');
                                                      //     setState(() {
                                                      //       _obscureTextPassword = !_obscureTextPassword;
                                                      //     });
                                                      //   },
                                                      //   child: Icon(
                                                      //     _obscureTextPassword
                                                      //         ? FontAwesomeIcons.eye
                                                      //         : FontAwesomeIcons.eyeSlash,
                                                      //     size: 15.0,
                                                      //     color: Colors.black,
                                                      //   ),
                                                      // ),
                                                    ),
                                                    controller:
                                                        passWordController,
                                                    focusNode: passFocus,

                                                    onSubmitted: (_) {
                                                      nameNFocus.requestFocus();
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              child: Column(
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        bottom: 5, top: 4),
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      'Tên',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18),
                                                    ),
                                                  ),
                                                  TextField(
                                                    maxLines: 1,
                                                    decoration: InputDecoration(
                                                      hintText: "Tên",
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelStyle: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    controller:
                                                        managerNameController,
                                                    focusNode: nameNFocus,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  okBtnText: 'Thêm', okBtnFunction: () {
                                if (phoneNController.text == null ||
                                    phoneNController.text == '' ||
                                    passWordController.text == null ||
                                    passWordController.text == '' ||
                                    managerNameController.text == null ||
                                    managerNameController.text == '') {
                                  _showSnackBar(
                                      'Vui lòng điền đầy đủ thông tin', false);
                                  // phoneNController.text = '';
                                  // passWordController.text = '';
                                  // managerNameController.text = '';
                                } else {
                                  BlocProvider.of<UserManagerBloc>(context).add(
                                      UserManagerEventRequested(
                                          phone: phoneNController.text,
                                          password: passWordController.text,
                                          name: managerNameController.text,
                                          clinicId: clinic.id));
                                  Navigator.of(context).pop();
                                }
                              }, titleStyle: null);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }

            if (state is ClinicStateFailure) {
              return Text('Lấy cơ sở lỗi!!!');
            }

            return Center(
              child: Container(
                margin: EdgeInsets.only(top: 30),
                height: 50,
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
                  padding: EdgeInsets.symmetric(horizontal: 45),
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  child: Text(
                    'Lấy danh sách cơ sở',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontFamily: 'WorkSansBold'),
                  ),
                  onPressed: () {
                    BlocProvider.of<ClinicBloc>(context).add(
                      ClinicEventRequested(),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
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
