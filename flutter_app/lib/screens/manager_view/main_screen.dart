import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/blocs/clinic_bloc.dart';
import 'package:flutter_app/blocs/dentist_bloc.dart';
import 'package:flutter_app/blocs/schedule_bloc.dart';
import 'package:flutter_app/customs/block_view.dart';
import 'package:flutter_app/customs/custom_circular_progress.dart';
import 'package:flutter_app/customs/snackbar.dart';
import 'package:flutter_app/customs/themes.dart';
import 'package:flutter_app/events/clinic_event.dart';
import 'package:flutter_app/events/dentist_event.dart';
import 'package:flutter_app/events/schedule_event.dart';
import 'package:flutter_app/models/clinic.dart';
import 'package:flutter_app/models/dentist.dart';
import 'package:flutter_app/models/schedule.dart';
import 'package:flutter_app/models/schedule_add.dart';
import 'package:flutter_app/screens/manager_view/manage_screen.dart';
import 'package:flutter_app/states/clinic_state.dart';
import 'package:flutter_app/states/dentist_state.dart';
import 'package:flutter_app/states/schedule_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Clinic _clinic;
  DentistData _dentist;
  List<DentistData> dentistData = [];
  List<Clinic> clinicList = [];
  List<bool> isSelected = List.generate(2, (_) => false);
  List<Schedule> scheduleList = [];
  Schedule _schedule;
  bool searched = false;
  String appointmentDate;
  int shiftWork = 0;
  Color colorAM = Colors.white;
  Color colorPM = Colors.white;

  void setColorSelected(int index) {
    setState(() {
      if (index == 1) {
        colorAM = Colors.white;
        colorPM = Colors.grey.shade900;
      } else {
        colorAM = Colors.grey.shade900;
        colorPM = Colors.white;
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
      shiftWork = 1;
    } else {
      shiftWork = 2;
    }
    setColorSelected(shiftWork);
    print('shiftWork: $shiftWork');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          title: Center(child: Text('Cảnh báo', style: TextStyle(color: Colors.redAccent),)),
          content: Container(height: 20 ,child: Center(child: Text('Bạn muốn đăng xuất?'))),
          actions: [
            // ignore: deprecated_member_use
            FlatButton(
              child: Text('Đồng ý',style: TextStyle(color: Colors.redAccent),),
              onPressed: () => {Navigator.pop(c, true)},
            ),
            // ignore: deprecated_member_use
            FlatButton(
              child: Text('Không',style: TextStyle(color: Colors.blueAccent),),
              onPressed: () => Navigator.pop(c, false),
            ),
          ],
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          // automaticallyImplyLeading: false,
          title: Center(
            child: Container(
              // margin: EdgeInsets.only(left: 70),
              child: Text(
                'Đặt lịch',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          backgroundColor: CustomTheme.loginGradientStart,
          actions: [
            Container(
              margin: EdgeInsets.only(right: 10),
              child: InkWell(
                onTap: () async {
                  //manage navigator
                  BlocProvider.of<ClinicBloc>(context).add(
                    ClinicEventRequested(),
                  );
                  bool shouldUpdate = await Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ManageScreen()));
                  if (shouldUpdate)
                    BlocProvider.of<ClinicBloc>(context).add(
                      ClinicEventRequested(),
                    );
                },
                child: Container(
                    width: 60,
                    height: 30,
                    child: Center(child: Icon(Icons.person))),
              ),
            )
          ],
        ),
        body: Container(
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
          // child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _header(context),
              //check nếu search thành công thì hiển thị schedule list
              if (searched)
                Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 200,
                      child: _contentSearch(context),
                    ))
            ],
          ),
          // ),
        ),
      ),
    );
  }

  Widget _contentSearch(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          child: Center(
            child: Text(
              'Lịch khám của ${_dentist.name}',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          margin: EdgeInsets.only(top: 20, bottom: 10),
        ),
        Divider(
          indent: 10,
          endIndent: 10,
          thickness: 2,
          color: Colors.grey,
          height: 0.0,
        ),
        Expanded(
            child: SizedBox(
          height: 200,
          child: Container(
            padding: EdgeInsets.only(bottom: 10),
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: BlocConsumer<ScheduleBloc, ScheduleState>(
              listener: (context, state) {
                if (state is ScheduleStateSuccess) {
                  setState(() {
                    scheduleList = state.response.data;
                  });
                }
                if (state is ScheduleStateFailure) {
                  _showSnackBar('lấy lịch lỗi', false);
                }
                if (state is ScheduleAddStateSuccess) {
                  print('state: ${state.response.data.id}');
                  BlocProvider.of<ScheduleBloc>(context).add(
                      ScheduleEventRequested(
                          dentistId: _dentist.id,
                          appointmentDate: appointmentDate,
                          workShift: shiftWork.toString()));
                }
                if (state is ScheduleDelStateSuccess) {
                  print('state: $state');
                  BlocProvider.of<ScheduleBloc>(context).add(
                      ScheduleEventRequested(
                          dentistId: _dentist.id,
                          appointmentDate: appointmentDate,
                          workShift: shiftWork.toString()));
                }
              },
              builder: (context, state) {
                if (state is ScheduleStateLoading) {
                  return CircularProgress();
                }
                if (state is ScheduleStateSuccess) {
                  return Container(
                    child: GridView(
                      shrinkWrap: true,
                      padding: EdgeInsets.all(15),
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 100,
                        childAspectRatio: 3 / 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                      ),
                      children: scheduleList
                          .map((item) => BlockItem(
                                dentistId: _dentist.id,
                                schedule: item,
                                appointmentDate: appointmentDate,
                              ))
                          .toList(),
                    ),
                  );
                }
                if (state is ScheduleStateFailure) {
                  return Center(
                    child: Text('getSchedule error'),
                  );
                }
                return Center(
                  child: Text('getSchedule error'),
                );
              },
            ),
          ),
        )),
      ],
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
                  child: CircularProgress()
              );
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
                ),
                Expanded(
                  flex: 0,
                  child: Container(
                    margin: const EdgeInsets.only(left: 10),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      color: Colors.white,
                    ),
                    child: ToggleButtons(
                      children: <Widget>[
                        Container(
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
                              shiftWork = 1;
                            } else {
                              shiftWork = 2;
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
                ),
              ],
            )),
        Container(
          // margin: const EdgeInsets.only(
          //   top: 15,
          // ),

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
                  'Tìm kiếm',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontFamily: 'WorkSansBold'),
                ),
              ),
            ),
            onPressed: () {
              setState(() {
                searched = true;
              });
              BlocProvider.of<ScheduleBloc>(context).add(ScheduleEventRequested(
                  dentistId: _dentist.id,
                  appointmentDate: appointmentDate,
                  workShift: shiftWork.toString()));
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

  DateTime selectedDate = DateTime.now();
  String title = 'Chọn ngày';

  bool _decideWhichDayToEnable(DateTime day) {
    if ((day.isAfter(DateTime.now().subtract(Duration(days: 1))) &&
        day.isBefore(DateTime.now().add(Duration(days: 10))))) {
      return true;
    }
    return false;
  }

  void _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      initialEntryMode: DatePickerEntryMode.input,
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2021),
      lastDate: DateTime(2050),
      // selectableDayPredicate: _decideWhichDayToEnable,
      errorFormatText: 'nhập sai định dạng',
      errorInvalidText: 'nhập sai',
    );
    if (picked != null)
      setState(() {
        selectedDate = picked;
        title = formatDate(selectedDate, [dd, '-', mm, '-', yyyy]);
        appointmentDate = formatDate(selectedDate, [yyyy, '-', mm, '-', dd]);
      });
  }
}