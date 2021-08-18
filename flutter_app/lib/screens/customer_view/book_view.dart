import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/blocs/schedule_bloc.dart';
import 'package:flutter_app/customs/block_cs_view.dart';
import 'package:flutter_app/customs/custom_circular_progress.dart';
import 'package:flutter_app/customs/snackbar.dart';
import 'package:flutter_app/customs/themes.dart';
import 'package:flutter_app/events/schedule_event.dart';
import 'package:flutter_app/models/schedule.dart';
import 'package:flutter_app/models/user.dart';
import 'package:flutter_app/states/schedule_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookView extends StatefulWidget {
  final User user;

  BookView({
    @required this.user,
  }) : assert(
          user != null,
        );

  @override
  _BookViewState createState() => _BookViewState();
}

class _BookViewState extends State<BookView> {
  String appointmentDate;
  int shiftWork = 0;
  Color colorAM = Colors.white;
  Color colorPM = Colors.white;
  List<bool> isSelected = List.generate(2, (_) => false);
  DateTime selectedDate = DateTime.now();
  String title = formatDate(DateTime.now(), [dd, '-', mm, '-', yyyy]);
  List<Schedule> scheduleList = [];
  bool startBooked = false;

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
    appointmentDate = formatDate(selectedDate, [yyyy, '-', mm, '-', dd]);
    setColorSelected(shiftWork);
    print('shiftWork: $shiftWork');

    if (!this.startBooked) {
      BlocProvider.of<ScheduleBloc>(context).add(ScheduleEventRequested(
          dentistId: widget.user.dentistId,
          appointmentDate: formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]),
          workShift: '1'));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isSelected[0] == null) {
      setState(() {
        isSelected[0] = true;
      });
    }

    return Container(
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
            Expanded(
              child: SizedBox(height: 200, child: _contentSearch(context)),
              flex: 3,
            )
          ],
        ));
  }

  Widget _contentSearch(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        /*Container(
          child: Center(
            child: Text(
              'Lịch khám của bác sỹ ${widget.user.dentistName}',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          margin: EdgeInsets.only(top: 20, bottom: 10),
        ),*/
        Container(
          margin: EdgeInsets.only(top: 20, bottom: 10),
          child: Divider(
            indent: 10,
            endIndent: 10,
            thickness: 2,
            color: Colors.grey,
            height: 0.0,
          ),
        ),
        Expanded(
          child: Container(
            // padding: EdgeInsets.only(bottom: 10),
            margin: EdgeInsets.symmetric(vertical: 1, horizontal: 5),
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
                  setState(() {
                    this.startBooked = false;
                  });
                  print('state: ${state.response.data.id}');
                  BlocProvider.of<ScheduleBloc>(context).add(
                      ScheduleEventRequested(
                          dentistId: widget.user.dentistId,
                          appointmentDate: appointmentDate,
                          workShift: shiftWork.toString()));
                }
                if (state is ScheduleDelStateSuccess) {
                  setState(() {
                    this.startBooked = false;
                  });
                  print('state: $state');
                  BlocProvider.of<ScheduleBloc>(context).add(
                      ScheduleEventRequested(
                          dentistId: widget.user.dentistId,
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
                      shrinkWrap: false,
                      padding: EdgeInsets.all(15),
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 100,
                        childAspectRatio: 3 / 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                      ),
                      children: scheduleList
                          .map((item) => BlockCSItem(
                                dentistId: widget.user.dentistId,
                                schedule: item,
                                patientId: widget.user.id,
                                patientName: widget.user.name,
                                appointmentDate: appointmentDate,
                                onChange: () {
                                  setState(() {
                                    this.startBooked = true;
                                  });
                                },
                              ))
                          .toList(),
                    ),
                  );
                }
                if (state is ScheduleStateFailure) {
                  return Center(
                    child: Text('Lấy thông tin lịch lỗi'),
                  );
                }
                return Center(
                  child: Text('Lấy thông tin lịch lỗi'),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _header(BuildContext context) {
    return Container(
      height: 230,
      child: Column(
        children: <Widget>[
          Container(
              child: Card(
            margin: EdgeInsets.only(left: 40, top: 20, right: 40),
            child: Column(
              children: [
                /*Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Tên nha sỹ:',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade900),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Center(
                          child: Text(
                        widget.user.dentistName,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: CustomTheme.loginGradientEnd),
                      ))
                    ],
                  ),
                ),
                Container(
                  width: 250.0,
                  height: 1.0,
                  color: Colors.grey[400],
                ),*/
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.only(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Tên người dùng: ',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade900),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Center(
                          child: Text(
                        widget.user.name,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: CustomTheme.loginGradientEnd),
                      ))
                    ],
                  ),
                )
              ],
            ),
          )),
          Expanded(
            child: Container(
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
          ),
          Container(
            height: 50,
            margin: EdgeInsets.symmetric(horizontal: 40.0),
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
                // setState(() {
                //   searched = true;
                // });
                BlocProvider.of<ScheduleBloc>(context).add(
                    ScheduleEventRequested(
                        dentistId: widget.user.dentistId,
                        appointmentDate: appointmentDate,
                        workShift: shiftWork.toString()));
              },
            ),
          ),
        ],
      ),
    );
  }

  bool _decideWhichDayToEnable(DateTime day) {
    if ((day.isAfter(DateTime.now().subtract(Duration(days: 1))) &&
        day.isBefore(DateTime.now().add(Duration(days: 10))))) {
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
