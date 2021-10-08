import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/blocs/list_work_bloc.dart';
import 'package:flutter_app/blocs/update_dentist_with_clinic_bloc.dart';
import 'package:flutter_app/customs/custom_circular_progress.dart';
import 'package:flutter_app/customs/snackbar.dart';
import 'package:flutter_app/customs/themes.dart';
import 'package:flutter_app/customs/utils.dart';
import 'package:flutter_app/events/list_work_event.dart';
import 'package:flutter_app/events/update_dentist_with_clinic_event.dart';
import 'package:flutter_app/models/dentist_update.dart';
import 'package:flutter_app/states/dentist_state.dart';
import 'package:flutter_app/states/list_work_state.dart';
import 'package:flutter_app/states/update_dentist_with_clinic_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateDentistWithCliniId extends StatefulWidget {
  @override
  _UpdateDentistWithCliniIdState createState() =>
      _UpdateDentistWithCliniIdState();
}

class _UpdateDentistWithCliniIdState extends State<UpdateDentistWithCliniId> {
  // List<DentistData> dentistData = [];
  List<Work> listWork = [];
  ResponseUpdateDentist response;
  List<Work> futureListWork = [];
  List<bool> _isCheckCS1;
  List<bool> _isCheckCS2;
  Map<String, dynamic> myDentist;
  List<Map<String, dynamic>> listMyDentist = [];

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
    }

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Container(
            // margin: EdgeInsets.only(left: 70),
            child: Text(
              'Thay đổi cơ sở',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        backgroundColor: CustomTheme.colorEnd,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 5),
            child: IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                for (int i = 0; i < _isCheckCS1.length; i++) {
                  print('CS: $i : ${_isCheckCS1[i]}');
                  print('CS2: $i : ${_isCheckCS2[i]}');
                  var _clinicId;
                  if (_isCheckCS1[i]) {
                    _clinicId = 1;
                  } else if (_isCheckCS2[i]) {
                    _clinicId = 2;
                  } else {
                    _clinicId = 0;
                  }

                  myDentist = {
                    'dentistId': listWork[i].dentistId,
                    'clinicId': _clinicId,
                  };
                  print(myDentist);
                  listMyDentist.add(myDentist);
                }
                print(listMyDentist);
                if (appointmentDate != null && appointmentDate != '') {
                  BlocProvider.of<UpdateDentistWithClinicBloc>(context).add(
                      UpdateDentistWithClinicEventRequested(
                          date: appointmentDate, listUpdate: listMyDentist));
                } else {
                  _showSnackBar('Vui lòng chọn ngày', false);
                }
              },
            ),
          ),
        ],
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: CustomTheme.primaryGradient,
          ),
          child: Stack(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 30),
                child: Column(
                  children: <Widget>[
                    Container(
                      // margin: EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Chọn ngày cài đặt',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 15, right: 15),
                            margin: EdgeInsets.only(right: 10),
                            height: 50,
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              color: Colors.white,
                            ),
                            child: MaterialButton(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              child: Container(
                                child: Text(
                                  title,
                                  style: TextStyle(
                                      color: Colors.grey.shade900,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              onPressed: () => _selectDate(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: BlocConsumer<ListWorkBloc, ListWorkState>(
                          listener: (context, state) {
                            if (state is ListWorkStateSuccess) {
                              setState(() {
                                // dentistData = state.response.dataList;
                                response = state.response;
                                listWork =
                                    response.updateData.presentUpdate.listWork;
                                futureListWork =
                                    response.updateData.futureUpdate.listWork;
                                _isCheckCS1 = List.generate(
                                    listWork.length, (index) => false);
                                _isCheckCS2 = List.generate(
                                    listWork.length, (index) => false);
                                for (int i = 0; i < listWork.length; i++) {
                                  if (listWork[i].clinicId != null) {
                                    _isCheckCS1[i] = listWork[i].clinicId == 1
                                        ? true
                                        : false;
                                    _isCheckCS2[i] = listWork[i].clinicId == 2
                                        ? true
                                        : false;
                                  } else {
                                    _isCheckCS1[i] = _isCheckCS2[i] = false;
                                  }
                                }
                              });
                              if (listWork == null || listWork.isEmpty) {
                                _showSnackBar('Không có dữ liệu!!!', false);
                              }
                            }
                            if (state is ListWorkStateLogout) {
                              // Navigator.popAndPushNamed(context, '/login');
                              Utils.gotoLogin(context);
                            }
                          },
                          builder: (context, state) {
                            if (state is ListWorkStateLoading) {
                              return CircularProgress();
                            }
                            return Container(
                              margin: EdgeInsets.only(top: 20, bottom: 20),
                              alignment: Alignment.topCenter,
                              padding: EdgeInsets.only(
                                  left: 16, right: 16, bottom: 5),
                              child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: false,
                                  itemCount: listWork.length,
                                  itemBuilder: (context, index) {
                                    final dentist = listWork[index];
                                    return Card(
                                      child: Container(
                                        padding: EdgeInsets.all(5.0),
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                                margin:
                                                    EdgeInsets.only(left: 10),
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    color: Colors.blueAccent),
                                                child: Icon(
                                                  Icons.person,
                                                  color: Colors.white,
                                                )),
                                            Expanded(
                                              child: Container(
                                                child: ListTile(
                                                  title: Text(
                                                      '${dentist.dentistName}'),
                                                  subtitle: Text(
                                                      'Số lịch đặt: ${dentist.count}'),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              child: Row(
                                                children: [
                                                  Text('CS1'),
                                                  Checkbox(
                                                    checkColor: Colors.white,
                                                    fillColor:
                                                        MaterialStateProperty
                                                            .resolveWith(
                                                                getColor),
                                                    value: _isCheckCS1[index],
                                                    onChanged: (bool value) {
                                                      setState(() {
                                                        _isCheckCS1[index] =
                                                            value;
                                                        _isCheckCS2[index] =
                                                            !value;
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              child: Row(
                                                children: [
                                                  Text('CS2'),
                                                  Checkbox(
                                                    checkColor: Colors.white,
                                                    fillColor:
                                                        MaterialStateProperty
                                                            .resolveWith(
                                                                getColor),
                                                    value: _isCheckCS2[index],
                                                    onChanged: (bool value) {
                                                      setState(() {
                                                        _isCheckCS1[index] =
                                                            !value;
                                                        _isCheckCS2[index] =
                                                            value;
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            );
                          },
                        ),
                      ),
                      flex: 5,
                    ),
                    Container(
                      height: 180,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(
                          left: 20, right: 20, bottom: 30, top: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      child: Column(
                        children: <Widget>[
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                  margin: EdgeInsets.only(
                                      left: 10, top: 10, bottom: 10),
                                  child: Text(
                                    'Lịch sắp tới',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  ))),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: <Widget>[Text('CS1: '), _getText(1)],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: <Widget>[Text('CS2: '), _getText(2)],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                              margin: EdgeInsets.only(left: 20, right: 20),
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: <Widget>[
                                  Text('Thời gian hiệu lực: '),
                                  Text(
                                      '${response != null ? response.updateData.futureUpdate.date : ''}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500)),
                                ],
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Center(
                child: Container(
                    margin: EdgeInsets.only(bottom: 30),
                    height: 100,
                    width: 100,
                    child: BlocConsumer<UpdateDentistWithClinicBloc,
                        UpdateDentistWithClinicState>(
                      listener: (context, state) {
                        if (state is UpdateDentistWithClinicSuccess) {
                          _showSnackBar('Cập nhật thành công', true);
                          BlocProvider.of<ListWorkBloc>(context)
                              .add(ListWorkEventRequested());
                        }
                        if (state is UpdateDentistWithClinicFailure) {
                          _showSnackBar('Cập nhật không thành công', false);
                          BlocProvider.of<ListWorkBloc>(context)
                              .add(ListWorkEventRequested());
                        }

                        if (state is UpdateDentistWithClinicLogout) {
                          // Navigator.popAndPushNamed(context, '/login');
                          Utils.gotoLogin(context);
                        }
                      },
                      builder: (context, state) {
                        if (state is UpdateDentistWithClinicLoading) {
                          return CircularProgress(
                            background: Colors.grey.shade200,
                          );
                        }
                        return Text('');
                      },
                    )),
              ),
            ],
          )),
    );
  }

  Text _getText(int cs) {
    if (cs == 1) {
      var listCS1 = '';
      for (int i = 0; i < futureListWork.length; i++) {
        listCS1 += futureListWork[i].clinicId == 1
            ? '${futureListWork[i].dentistName}, '
            : '';
      }
      return Text(' $listCS1',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500));
    } else if (cs == 2) {
      var listCS2 = '';
      for (int i = 0; i < futureListWork.length; i++) {
        listCS2 += futureListWork[i].clinicId == 2
            ? '${futureListWork[i].dentistName}, '
            : '';
      }
      return Text(' $listCS2',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500));
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

  DateTime selectedDate = DateTime.now().add(Duration(days: 1));
  String title = 'Chọn ngày';
  String appointmentDate;

  bool _decideWhichDayToEnable(DateTime day) {
    // ignore: unrelated_type_equality_checks
    if (day.isAfter(DateTime.now().subtract(Duration(days: 1)))) {
      return true;
    }
    return false;
  }

  void _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      initialEntryMode: DatePickerEntryMode.calendar,
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2021),
      lastDate: DateTime(2050),
      selectableDayPredicate: _decideWhichDayToEnable,
      errorFormatText: 'nhập sai định dạng',
      errorInvalidText: 'nhập sai',
    );
    if (picked != null) {
      DateTime now = new DateTime.now();
      print('$picked === ${DateTime(now.year, now.month, now.day)}');
      if (picked == DateTime(now.year, now.month, now.day)) {
        _showSnackBar('Bạn không được chọn ngày hiện tại', false);
        selectedDate = DateTime.now().add(Duration(days: 1));
        appointmentDate = '';
      } else {
        setState(() {
          selectedDate = picked;
          title = formatDate(selectedDate, [dd, '-', mm, '-', yyyy]);
          appointmentDate = formatDate(selectedDate, [yyyy, '-', mm, '-', dd]);
        });
      }
    }
  }
}
