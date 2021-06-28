import 'package:flutter/material.dart';
import 'package:flutter_app/blocs/dentist_bloc.dart';
import 'package:flutter_app/customs/custom_circular_progress.dart';
import 'package:flutter_app/customs/snackbar.dart';
import 'package:flutter_app/customs/themes.dart';
import 'package:flutter_app/customs/utils.dart';
import 'package:flutter_app/events/dentist_event.dart';
import 'package:flutter_app/models/dentist.dart';
import 'package:flutter_app/screens/new/add_screen/add_dentist.dart';
import 'package:flutter_app/states/clinic_state.dart';
import 'package:flutter_app/states/dentist_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class DentistScreen extends StatefulWidget {
  final String clinicId;

  DentistScreen({@required this.clinicId}) : assert(clinicId != null);

  @override
  _DentistScreenState createState() => _DentistScreenState();
}

class _DentistScreenState extends State<DentistScreen> {
  List<DentistData> dentistList = [];
  bool shouldUpdate = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  FocusNode nameFocus = FocusNode();
  FocusNode phoneFocus = FocusNode();

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
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: InkWell(
              onTap: () async {
                final shouldUpdate2 =
                    await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AddDentistScreen(
                              clinicId: widget.clinicId,
                            )));
                setState(() {
                  this.shouldUpdate = shouldUpdate2;
                  if (shouldUpdate) {
                    BlocProvider.of<DentistBloc>(context).add(
                      DentistEventRequested(clinicId: widget.clinicId),
                    );
                  }
                });
              },
              child: Container(
                  width: 60,
                  height: 30,
                  child: Center(
                      child: Icon(
                    Icons.add,
                    size: 35,
                  ))),
            ),
          )
        ],
        backgroundColor: CustomTheme.loginGradientStart,
        title: Center(
          child: Container(
            child: Text(
              'Quản lý nha sỹ',
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
        padding: EdgeInsets.only(bottom: 20),
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
        child: BlocConsumer<DentistBloc, DentistState>(
          listener: (context, state) {
            if (state is DentistStateSuccess) {
              setState(() {
                dentistList = state.response.dataList;
              });
              print('dentist: ${dentistList.first.name}');
              if (shouldUpdate) {
                setState(() {
                  shouldUpdate = false;
                });
                _showSnackBar('Thêm nha sỹ thành công', true);
              }
            } else if (state is DentistEditStateSuccess) {
              BlocProvider.of<DentistBloc>(context).add(
                DentistEventRequested(clinicId: widget.clinicId),
              );
              _showSnackBar('Sửa nha sỹ thành công', true);
            } else if (state is DentistDelStateSuccess) {
              BlocProvider.of<DentistBloc>(context).add(
                DentistEventRequested(clinicId: widget.clinicId),
              );
              _showSnackBar('Xóa nha sỹ thành công', true);
            }
          },
          builder: (context, state) {
            if (state is DentistStateLoading) {
              return CircularProgress();
            }

            if (state is DentistStateSuccess ||
                state is DentistEditStateSuccess ||
                state is DentistDelStateSuccess) {
              return Container(
                margin: EdgeInsets.all(10),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: dentistList.length,
                  itemBuilder: (context, index) {
                    final dentist = dentistList[index];
                    return Card(
                      child: Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 1 / 5,
                        child: ListTile(
                          title: Text(dentist.name),
                          subtitle: Text(dentist.phone),
                          onTap: () {},
                        ),
                        secondaryActions: <Widget>[
                          new IconSlideAction(
                            caption: 'Sửa',
                            color: Colors.black45,
                            icon: Icons.edit,
                            onTap: () => {
                              nameController.text = dentist.name,
                              phoneController.text = dentist.phone,
                              DialogUtils.showCustomDialog(context,
                                  title: 'Sửa thông tin chi nhánh',
                                  child: GestureDetector(
                                    onTap: () {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                    },
                                    child: Container(
                                      height: 200,
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
                                                      'Tên nha sỹ',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18),
                                                    ),
                                                  ),
                                                  TextField(
                                                    maxLines: 1,
                                                    decoration: InputDecoration(
                                                      hintText: dentist.name,
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
                                                      hintText: dentist.phone,
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelStyle: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    controller: phoneController,
                                                    focusNode: phoneFocus,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  okBtnText: 'Lưu', okBtnFunction: () {
                                BlocProvider.of<DentistBloc>(context)
                                    .add(DentistEditEventRequested(
                                  dentistId: dentist.id,
                                  name: nameController.text,
                                  phone: phoneController.text,
                                ));
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
                                    'Bạn muốn xóa nha sỹ \'${dentist.name}\' khỏi danh sách?',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.center,
                                  ),
                                  okBtnText: 'Xóa', okBtnFunction: () {
                                BlocProvider.of<DentistBloc>(context).add(
                                  DentistDelEventRequested(
                                      dentistId: dentist.id),
                                );
                                Navigator.of(context).pop();
                              })
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }

            if (state is ClinicStateFailure) {
              return Text('get Dentist some thing went wrong!!!');
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
                    'Lấy danh sách nha sỹ',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontFamily: 'WorkSansBold'),
                  ),
                  onPressed: () {
                    BlocProvider.of<DentistBloc>(context).add(
                      DentistEventRequested(clinicId: widget.clinicId),
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
}
