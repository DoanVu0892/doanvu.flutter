import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/blocs/clinic_bloc.dart';
import 'package:flutter_app/blocs/dentist_bloc.dart';
import 'package:flutter_app/blocs/leave_schedule_bloc.dart';
import 'package:flutter_app/blocs/schedule_bloc.dart';
import 'package:flutter_app/customs/custom_circular_progress.dart';
import 'package:flutter_app/customs/snackbar.dart';
import 'package:flutter_app/customs/themes.dart';
import 'package:flutter_app/events/dentist_event.dart';
import 'package:flutter_app/events/leave_schedule_event.dart';
import 'package:flutter_app/events/schedule_event.dart';
import 'package:flutter_app/models/clinic.dart';
import 'package:flutter_app/models/dentist.dart';
import 'package:flutter_app/models/utils_constant.dart';
import 'package:flutter_app/states/clinic_state.dart';
import 'package:flutter_app/states/dentist_state.dart';
import 'package:flutter_app/states/leave_schedule_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LeaveScheduleView extends StatefulWidget {
  @override
  _LeaveScheduleViewState createState() => _LeaveScheduleViewState();
}

class _LeaveScheduleViewState extends State<LeaveScheduleView> {
  Clinic _clinic;
  DentistData _dentist;
  List<DentistData> dentistData = [];
  List<Clinic> clinicList = [];
  String shiftWork = 'am';
  List<bool> isSelected = List.generate(3, (_) => false);
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();
  String titleStartDate = formatDate(DateTime.now(), [dd, '-', mm, '-', yyyy]);
  String titleEndDate = formatDate(DateTime.now(), [dd, '-', mm, '-', yyyy]);
  String startDate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
  String endDate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);

  Color colorAM = Colors.white;
  Color colorPM = Colors.white;
  Color colorAll = Colors.white;

  TextEditingController noteController = TextEditingController();
  FocusNode noteFocus = FocusNode();
  bool showShift = true;

  void setColorSelected(String shiftWork) {
    setState(() {
      switch (shiftWork) {
        case 'am':
          colorAM = Colors.white;
          colorPM = Colors.grey.shade900;
          colorAll = Colors.grey.shade900;
          break;
        case 'pm':
          colorAM = Colors.grey.shade900;
          colorPM = Colors.white;
          colorAll = Colors.grey.shade900;
          break;
        case 'all':
          colorAM = Colors.grey.shade900;
          colorPM = Colors.grey.shade900;
          colorAll = Colors.white;
          break;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isSelected[0] = true;
    });
    if (isSelected[0] == true) {
      shiftWork = 'am';
    } else if (isSelected[1] == true) {
      shiftWork = 'pm';
    } else {
      shiftWork = 'all';
    }
    setColorSelected(shiftWork);
    print('shiftWork: $shiftWork');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Container(
            margin: EdgeInsets.only(right: 50),
            child: Text(
              'Đặt lịch nghỉ',
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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _header(context),
                BlocConsumer<LeaveScheduleBloc, LeaveScheduleState>(
                  listener: (context, state) {
                    if (state is LeaveScheduleSuccess) {
                      _showSnackBar("Đặt lịch nghỉ thành công", true);
                    }
                    if (state is LeaveScheduleFailure) {
                      _showSnackBar('Đặt lịch nghỉ lỗi', false);
                    }
                    new Future.delayed(
                        const Duration(milliseconds: Constant.duration), () {
                      Navigator.pop(context);
                    });
                  },
                  builder: (context, state) {
                    if (state is LeaveScheduleLoading) {
                      return CircularProgress();
                    }
                    if (state is LeaveScheduleFailure) {
                      _showSnackBar('Đặt lịch nghỉ lỗi', false);
                      return Text('');
                    }
                    return Text('');
                  },
                )
                //check nếu search thành công thì hiển thị schedule list
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            child: BlocConsumer<ClinicBloc, ClinicState>(
          listener: (context, state) {
            if (state is ClinicStateSuccess) {
              setState(() {
                clinicList = state.response.dataList;
              });
              if (clinicList == null || clinicList.isEmpty) {
                setState(() {});
              }
            }
          },
          builder: (context, state) {
            if (state is ClinicStateLoading) {
              return Container(
                  padding: EdgeInsets.only(top: 40, bottom: 20),
                  child: CircularProgress());
            }
            return clinicList != null
                ? Text('')
                : Container(
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
                      onPressed: () {},
                    ),
                  );
          },
        )),
        Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.only(left: 22, right: 10),
                  margin: EdgeInsets.symmetric(vertical: 0, horizontal: 40),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    color: Colors.white,
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(canvasColor: Colors.white),
                    child: DropdownButton<Clinic>(
                      isExpanded: true,
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey.shade900,
                          fontWeight: FontWeight.w400),
                      hint: Text(
                        "Chọn chi nhánh",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey.shade900,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      value: _clinic,
                      items: clinicList.map((Clinic clinic) {
                        return DropdownMenuItem<Clinic>(
                          value: clinic,
                          child: Container(
                            color: Colors.transparent,
                            child: new Text(clinic.name),
                          ),
                        );
                      }).toList(),
                      onChanged: (data) {
                        print('value $data');
                        setState(() {
                          this._clinic = data;
                        });
                        BlocProvider.of<DentistBloc>(context)
                            .add(DentistEventRequested(clinicId: _clinic.id));
                      },
                    ),
                  ))
            ],
          ),
        ),
        Container(
          child: BlocConsumer<DentistBloc, DentistState>(
            listener: (context, state) {
              if (state is DentistStateSuccess) {
                setState(() {
                  dentistData = state.response.dataList;
                });
                if (dentistData == null || dentistData.isEmpty) {
                  _showSnackBar('Không có dữ liệu!!!', false);
                }
              }
            },
            builder: (context, state) {
              if (state is DentistStateLoading) {
                return CircularProgress();
              }
              return Container(
                alignment: Alignment.topCenter,
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 5),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 0, horizontal: 40),
                      padding: EdgeInsets.only(left: 22, right: 10),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        color: Colors.white,
                      ),
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(canvasColor: Colors.white),
                        child: DropdownButton<DentistData>(
                          isExpanded: true,
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey.shade900,
                              fontWeight: FontWeight.w400),
                          hint: Text(
                            "Chọn nha sỹ",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey.shade900,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          value: _dentist,
                          items: dentistData.map((DentistData dentist) {
                            return DropdownMenuItem<DentistData>(
                              value: dentist,
                              child: Container(
                                color: Colors.transparent,
                                child: new Text(dentist.name),
                              ),
                            );
                          }).toList(),
                          onChanged: (data) {
                            print('value $data');
                            setState(() {
                              this._dentist = data;
                            });
                          },
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
        Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Center(
                      child: Text('Từ ngày',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white)),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Center(
                      child: Text(
                        'Đến ngày',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            )),
        Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.only(right: 10),
                    height: 50,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      color: Colors.white,
                    ),
                    child: MaterialButton(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      child: Container(
                        child: Text(
                          titleStartDate,
                          style: TextStyle(
                              color: Colors.grey.shade900,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      onPressed: () => _selectStartDate(context),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    height: 50,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      color: Colors.white,
                    ),
                    child: MaterialButton(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      child: Container(
                        child: Text(
                          titleEndDate,
                          style: TextStyle(
                              color: Colors.grey.shade900,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      onPressed: () => _selectEndDate(context),
                    ),
                  ),
                ),
              ],
            )),
        if (showShift)
          Container(
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              color: Colors.white,
            ),
            child: ToggleButtons(
              children: <Widget>[
                Container(
                  width: 88,
                  child: Center(
                    child: Text(
                      'SA',
                      style: TextStyle(
                          color: colorAM,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  width: 84,
                  child: Center(
                    child: Text(
                      'CH',
                      style: TextStyle(
                          color: colorPM,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  width: 88,
                  child: Center(
                    child: Text(
                      'ALL',
                      style: TextStyle(
                          color: colorAll,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
              onPressed: (int index) {
                if (isSelected[index] != true) {
                  setState(() {
                    for (int buttonIndex = 0;
                        buttonIndex < isSelected.length;
                        buttonIndex++) {
                      if (buttonIndex == index) {
                        isSelected[index] = !isSelected[index];
                      } else {
                        isSelected[buttonIndex] = false;
                      }
                    }
                    if (isSelected[0] == true) {
                      shiftWork = 'am';
                    } else if (isSelected[1] == true) {
                      shiftWork = 'pm';
                    } else {
                      shiftWork = 'all';
                    }
                    print('shiftWork: $shiftWork');
                    setColorSelected(shiftWork);
                  });
                }
              },
              isSelected: isSelected,
              fillColor: CustomTheme.loginGradientEnd,
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderColor: Colors.white,
              selectedBorderColor: Colors.white,
            ),
          ),
        Container(
          height: 50,
          padding: EdgeInsets.only(left: 10, right: 10),
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 55),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: Colors.white),
          child: TextField(
            focusNode: noteFocus,
            controller: noteController,
            style: const TextStyle(
                fontFamily: 'WorkSansSemiBold',
                fontSize: 16.0,
                color: Colors.black),
            decoration: InputDecoration(
              border: InputBorder.none,
              icon: Icon(Icons.edit),
              hintText: 'Nhập ghi chú',
              hintStyle: const TextStyle(
                  fontFamily: 'WorkSansSemiBold', fontSize: 17.0),
            ),
          ),
        ),
        Container(
          height: 50,
          margin: EdgeInsets.symmetric(horizontal: 55.0, vertical: 10),
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
            splashColor: CustomTheme.loginGradientStart,
            child: Container(
              child: Center(
                child: Text(
                  'Đặt lịch nghỉ',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontFamily: 'WorkSansBold'),
                ),
              ),
            ),
            onPressed: () {
              if (_dentist != null) {
                BlocProvider.of<LeaveScheduleBloc>(context).add(
                    LeaveScheduleEventRequested(
                        dentistId: _dentist.id,
                        startDate: startDate,
                        endDate: endDate,
                        shiftWork: shiftWork,
                        reason: noteController.text.isEmpty
                            ? ''
                            : noteController.text));
              } else {
                _showSnackBar('Vui lòng chọn đầy đủ thông tin', false);
              }
            },
          ),
        )
      ],
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

  void _selectStartDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      initialEntryMode: DatePickerEntryMode.calendar,
      context: context,
      initialDate: selectedStartDate,
      firstDate: DateTime(2021),
      lastDate: DateTime(2050),
      // selectableDayPredicate: _decideWhichDayToEnable,
      errorFormatText: 'nhập sai định dạng',
      errorInvalidText: 'nhập sai',
    );
    if (picked != null)
      setState(() {
        selectedStartDate = picked;
        titleStartDate =
            formatDate(selectedStartDate, [dd, '-', mm, '-', yyyy]);
        startDate = formatDate(selectedStartDate, [yyyy, '-', mm, '-', dd]);
        if (endDate == startDate) {
          showShift = true;
        } else {
          showShift = false;
        }
      });

    print("showShift: $showShift");
  }

  void _selectEndDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      initialEntryMode: DatePickerEntryMode.calendar,
      context: context,
      initialDate: selectedEndDate,
      firstDate: DateTime(2021),
      lastDate: DateTime(2050),
      // selectableDayPredicate: _decideWhichDayToEnable,
      errorFormatText: 'nhập sai định dạng',
      errorInvalidText: 'nhập sai',
    );
    if (picked != null)
      setState(() {
        selectedEndDate = picked;
        titleEndDate = formatDate(selectedEndDate, [dd, '-', mm, '-', yyyy]);
        endDate = formatDate(selectedEndDate, [yyyy, '-', mm, '-', dd]);
        if (endDate == startDate) {
          showShift = true;
        } else {
          showShift = false;
        }
      });

    print("showShift: $showShift");
  }
}
