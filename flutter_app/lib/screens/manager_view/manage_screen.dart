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
        // actions: [
        //   Container(
        //     margin: EdgeInsets.only(right: 10),
        //     child: InkWell(
        //       onTap: () async {
        //         final shouldUpdate2 = await Navigator.of(context).push(
        //             MaterialPageRoute(builder: (context) => AddClinicScreen()));
        //         setState(() {
        //           this.shouldUpdate = shouldUpdate2;
        //           if (shouldUpdate) {
        //             BlocProvider.of<ClinicBloc>(context).add(
        //               ClinicEventRequested(),
        //             );
        //           }
        //         });
        //       },
        //       child: Container(
        //           width: 60,
        //           height: 30,
        //           child: Center(
        //               child: Icon(
        //             Icons.add,
        //             size: 35,
        //           ))),
        //     ),
        //   )
        // ],
        backgroundColor: CustomTheme.loginGradientStart,
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
                  BlocConsumer<UserManagerBloc, UserManagerState>(listener: (context, state){
                   if(state is UserManagerStateSuccess){
                      _showSnackBar("Thêm thành công", true);
                   }
                   if(state is UserManagerStateFailure){
                     _showSnackBar("Thêm không thành công", false);
                   }

                  },
                  builder: (context, state){
                    if(state is UserManagerStateLoading){
                      return Container(
                          margin: EdgeInsets.only(top: 20),
                          child: CircularProgress());
                    }
                    return Text('');
                  },),
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
                                    color: CustomTheme.loginGradientEnd),
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
                              });
                            },
                          ),
                          /*child: Slidable(
                            actionPane: SlidableDrawerActionPane(),
                            actionExtentRatio: 1 / 5,
                            child: ListTile(
                              leading: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: CustomTheme.loginGradientEnd),
                                  child: Icon(
                                    Icons.home,
                                    color: Colors.white,
                                  )),
                              title: Text(clinic.name),
                              subtitle: Text(clinic.address),
                              onTap: () {
                                BlocProvider.of<DentistBloc>(context)
                                    .add(DentistEventRequested());
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DentistScreen(clinicId: clinic.id)));
                              },
                            ),
                            secondaryActions: <Widget>[
                              new IconSlideAction(
                                caption: 'Sửa',
                                color: Colors.black45,
                                icon: Icons.edit,
                                onTap: () => {
                                  nameController.text = clinic.name,
                                  phoneController.text = clinic.phone,
                                  addressController.text = clinic.address,
                                  DialogUtils.showCustomDialog(context,
                                      title: 'Sửa thông tin chi nhánh',
                                      child: GestureDetector(
                                        onTap: () {
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                        },
                                        child: Container(
                                          height: 305,
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
                                                            bottom: 5),
                                                        alignment:
                                                            Alignment.centerLeft,
                                                        child: Text(
                                                          'Tên chi nhánh',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              fontSize: 18),
                                                        ),
                                                      ),
                                                      TextField(
                                                        maxLines: 1,
                                                        decoration: InputDecoration(
                                                          hintText: clinic.name,
                                                          border:
                                                              OutlineInputBorder(),
                                                          labelStyle: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight.bold),
                                                        ),
                                                        controller: nameController,
                                                        focusNode: nameFocus,
                                                        onSubmitted: (_) {
                                                          phoneFocus.requestFocus();
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
                                                            bottom: 5, top: 5),
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
                                                        keyboardType:
                                                            TextInputType.phone,
                                                        decoration: InputDecoration(
                                                          hintText: clinic.phone,
                                                          border:
                                                              OutlineInputBorder(),
                                                          labelStyle: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight.bold),
                                                        ),
                                                        controller: phoneController,
                                                        focusNode: phoneFocus,
                                                        onSubmitted: (_) {
                                                          addressFocus
                                                              .requestFocus();
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
                                                            bottom: 5, top: 5),
                                                        alignment:
                                                            Alignment.centerLeft,
                                                        child: Text(
                                                          'Địa chỉ',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              fontSize: 18),
                                                        ),
                                                      ),
                                                      TextField(
                                                        maxLines: 1,
                                                        decoration: InputDecoration(
                                                          hintText: clinic.address,
                                                          border:
                                                              OutlineInputBorder(),
                                                          labelStyle: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight.bold),
                                                        ),
                                                        controller:
                                                            addressController,
                                                        focusNode: addressFocus,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      okBtnText: 'Lưu', okBtnFunction: () {
                                    BlocProvider.of<ClinicBloc>(context).add(
                                        ClinicEditEventRequested(
                                            clinicId: clinic.id,
                                            name: nameController.text,
                                            phone: phoneController.text,
                                            address: addressController.text));
                                    Navigator.of(context).pop();
                                  })
                                },
                              ),
                              new IconSlideAction(
                                caption: 'Xóa',
                                color: Colors.red,
                                icon: Icons.delete,
                                onTap: () => {
                                  print('onDel'),
                                  DialogUtils.showCustomDialog(context,
                                      title: 'Cảnh báo',
                                      titleStyle: TextStyle(color: Colors.red),
                                      child: Text(
                                        'Bạn muốn xóa chi nhánh \'${clinic.name}\' khỏi danh sách?',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400),
                                        textAlign: TextAlign.center,
                                      ),
                                      okBtnText: 'Xóa', okBtnFunction: () {
                                    BlocProvider.of<ClinicBloc>(context).add(
                                      ClinicDelEventRequested(clinicId: clinic.id),
                                    );
                                    Navigator.of(context).pop();
                                  })
                                },
                              ),
                            ],
                          ),*/
                        );
                      },
                    ),
                  ),
                ],
              );
            }

            if (state is ClinicStateFailure) {
              return Text('get Clinic some thing went wrong!!!');
            }

            return Center(
              child: Container(
                margin: EdgeInsets.only(top: 30),
                height: 50,
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
