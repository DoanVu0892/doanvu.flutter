import 'package:alert/alert.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/blocs/clinic_bloc.dart';
import 'package:flutter_app/blocs/dentist_bloc.dart';
import 'package:flutter_app/blocs/feedback_bloc.dart';
import 'package:flutter_app/blocs/list_work_bloc.dart';
import 'package:flutter_app/blocs/notify_bloc.dart';
import 'package:flutter_app/blocs/schedule_bloc.dart';
import 'package:flutter_app/customs/block_view.dart';
import 'package:flutter_app/customs/custom_circular_progress.dart';
import 'package:flutter_app/customs/snackbar.dart';
import 'package:flutter_app/customs/themes.dart';
import 'package:flutter_app/customs/utils.dart';
import 'package:flutter_app/events/clinic_event.dart';
import 'package:flutter_app/events/dentist_event.dart';
import 'package:flutter_app/events/feedback_event.dart';
import 'package:flutter_app/events/list_work_event.dart';
import 'package:flutter_app/events/notify_event.dart';
import 'package:flutter_app/events/schedule_event.dart';
import 'package:flutter_app/models/clinic.dart';
import 'package:flutter_app/models/dentist.dart';
import 'package:flutter_app/models/schedule.dart';
import 'package:flutter_app/repositories/app_repository.dart';
import 'package:flutter_app/screens/manager_view/leave_schedule/leave_schedule.dart';
import 'package:flutter_app/screens/manager_view/update_dentist_with_clinicId.dart';
import 'package:flutter_app/states/clinic_state.dart';
import 'package:flutter_app/states/dentist_state.dart';
import 'package:flutter_app/states/schedule_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oktoast/oktoast.dart';

import 'feedbacklist_view.dart';
import 'manage_screen.dart';
import 'notify_manager_view.dart';

class MainScreen extends StatefulWidget {
  final AppRepository appRepository;

  const MainScreen({@required this.appRepository})
      : assert(appRepository != null);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
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
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      return;
    } else if (state == AppLifecycleState.paused) {
      print('run onBackground');
    } else if (state == AppLifecycleState.resumed) {
      print('accessToken: ${widget.appRepository.accessToken}');
      final checkLogin = await widget.appRepository.checkLogin();
      print('call checkLogin API: $checkLogin');
      if (checkLogin && widget.appRepository.isLogin) {
        final abc = await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (c) => AlertDialog(
            title: Center(
                child: Text(
              'Cảnh báo',
              style: TextStyle(color: Colors.redAccent),
            )),
            content: Container(
              alignment: Alignment.center,
              height: 40,
              child: Center(
                  child: Text(
                'Phiên đăng nhập đã hết hạn\n Bạn cần đăng nhập lại!',
                textAlign: TextAlign.center,
              )),
            ),
            actions: [
              FlatButton(
                child: Text(
                  'Đồng ý',
                  style: TextStyle(color: Colors.redAccent),
                ),
                onPressed: () => {
                  // Navigator.popAndPushNamed(context, '/login'),
                  Navigator.pop(context, true),
                  widget.appRepository.isLogin = false,
                },
              ),
            ],
          ),
        );
        if (abc) {
          Navigator.pop(context, true);
        }
      }
    }
  }

  void handleClick(String value) async {
    switch (value) {
      case 'Quản lý':
        {
          //manage navigator
          BlocProvider.of<ClinicBloc>(context).add(
            ClinicEventRequested(),
          );
          bool shouldUpdate = await Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => ManageScreen()));
          if (shouldUpdate && shouldUpdate != null)
            BlocProvider.of<ClinicBloc>(context).add(
              ClinicEventRequested(),
            );
        }
        break;
      case 'Lịch nghỉ':
        {
          print('onClick Cài đặt lịch nghỉ');
          BlocProvider.of<DentistBloc>(context).add(
            DentistEventRequested(),
          );
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => LeaveScheduleView()));
        }
        break;
      case 'Thông báo':
        {
          print('onClick Alert');
          BlocProvider.of<NotifyBloc>(context)
              .add(NotifyManagerEventRequested());
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => NotifyManagerView()));
        }
        break;
      case 'Quản lý bác sỹ':
        {
          print('onClick Quản lý bác sỹ');
          BlocProvider.of<ListWorkBloc>(context).add(ListWorkEventRequested());
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => UpdateDentistWithCliniId()));
        }
        break;
      case 'Phản hồi khách hàng':
        {
          print('onClick Phản hồi khách hàng');
          BlocProvider.of<FeedBackBloc>(context).add(FeedbackEventRequested());
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => FeedBackListView()));
        }
        break;
    }
  }

  Icon _getIconWithChoice(String choice) {
    switch (choice) {
      case 'Quản lý':
        return Icon(Icons.person_add, color: Colors.blueAccent);
      case 'Lịch nghỉ':
        return Icon(Icons.schedule, color: Colors.blueAccent);
      case 'Thông báo':
        return Icon(Icons.notifications, color: Colors.blueAccent);
      case 'Quản lý bác sỹ':
        return Icon(Icons.manage_accounts, color: Colors.blueAccent);
      case 'Phản hồi khách hàng':
        return Icon(Icons.report, color: Colors.blueAccent);
      default:
        return Icon(Icons.manage_accounts, color: Colors.blueAccent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          title: Center(
              child: Text(
            'Cảnh báo',
            style: TextStyle(color: Colors.redAccent),
          )),
          content: Container(
              height: 20, child: Center(child: Text('Bạn muốn đăng xuất?'))),
          actions: [
            // ignore: deprecated_member_use
            FlatButton(
              child: Text(
                'Đồng ý',
                style: TextStyle(color: Colors.redAccent),
              ),
              onPressed: () => {Navigator.pop(c, true)},
            ),
            // ignore: deprecated_member_use
            FlatButton(
              child: Text(
                'Không',
                style: TextStyle(color: Colors.blueAccent),
              ),
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
          backgroundColor: CustomTheme.colorEnd,
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: handleClick,
              itemBuilder: (BuildContext context) {
                return {
                  'Quản lý',
                  'Lịch nghỉ',
                  'Thông báo',
                  'Quản lý bác sỹ',
                  'Phản hồi khách hàng'
                }.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          _getIconWithChoice(choice),
                          SizedBox(
                            width: 10,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Center(
                                child: Text(
                              choice,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 18),
                            )),
                          )
                        ],
                      ),
                    ),
                  );
                }).toList();
              },
              icon: Container(
                  margin: EdgeInsets.only(right: 10), child: Icon(Icons.menu)),
            ),
          ],
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: CustomTheme.primaryGradient,
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
              'Lịch khám của bác sỹ ${_dentist.name}',
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
                if (state is ScheduleStateLogout) {
                  // Navigator.popAndPushNamed(context, '/login');
                  Utils.gotoLogin(context);
                }

                if (state is ScheduleAddStateSuccess) {
                  if (state.response.status == 'ok') {
                    _showSnackBar('Đặt lịch thành công', true);
                  } else {
                    _showToast('Đặt lịch lỗi', '${state.response.message}',
                        false, () {});
                  }
                  BlocProvider.of<ScheduleBloc>(context).add(
                      ScheduleEventRequested(
                          dentistId: _dentist.id,
                          appointmentDate: appointmentDate,
                          workShift: shiftWork.toString()));
                }
                if (state is ScheduleAddStateFailure) {
                  _showSnackBar('Đặt lịch lỗi', false);
                }

                if (state is ScheduleDelStateSuccess) {
                  print('state: $state');
                  if (state.response.status == 'ok') {
                    _showSnackBar('Hủy lịch thành công', true);
                  } else {
                    _showToast('Hủy lịch lỗi', '${state.response.message}',
                        false, () {});
                  }
                  BlocProvider.of<ScheduleBloc>(context).add(
                      ScheduleEventRequested(
                          dentistId: _dentist.id,
                          appointmentDate: appointmentDate,
                          workShift: shiftWork.toString()));
                }
                if (state is ScheduleDelStateFailure) {
                  _showSnackBar('Xóa lịch lỗi', false);
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
                    child: Text('Lấy lịch lỗi'),
                  );
                }
                return Center(
                  child: Text('Lấy lịch lỗi'),
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
            child: BlocConsumer<DentistBloc, DentistState>(
          listener: (context, state) {
            if (state is DentistStateSuccess) {
              setState(() {
                dentistData = state.response.dataList;
              });
              if (dentistData == null || dentistData.isEmpty) {
                setState(() {});
              }
            }
            if (state is DentistStateLogout) {
              // Navigator.popAndPushNamed(context, '/login');
              Utils.gotoLogin(context);
            }
          },
          builder: (context, state) {
            if (state is DentistStateLoading) {
              return Container(
                  padding: EdgeInsets.only(top: 40, bottom: 20),
                  child: CircularProgress());
            }
            return dentistData != null
                ? Text('')
                : Container(
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
                        'Lấy danh sách nha sỹ',
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
                margin: EdgeInsets.symmetric(vertical: 0, horizontal: 40),
                padding: EdgeInsets.only(left: 22, right: 10),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  color: Colors.white,
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(canvasColor: Colors.white),
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
                      fillColor: CustomTheme.colorStart,
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
              gradient: CustomTheme.primaryGradient),
          child: MaterialButton(
            highlightColor: Colors.transparent,
            splashColor: CustomTheme.colorStart,
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
              if (_dentist != null && appointmentDate != null) {
                setState(() {
                  searched = true;
                });
                BlocProvider.of<ScheduleBloc>(context).add(
                    ScheduleEventRequested(
                        dentistId: _dentist.id,
                        appointmentDate: appointmentDate,
                        workShift: shiftWork.toString()));
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

  void _showToast(
      String title, String msg, bool success, VoidCallback dismiss) {
    showToastWidget(
      Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          height: 140,
          width: 250,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 15,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      success ? Icons.done : Icons.warning_amber_outlined,
                      color: success ? Colors.green : Colors.red,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    msg,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      duration: Duration(seconds: 3),
      onDismiss: dismiss != null ? dismiss : () {},
    );
  }

  DateTime selectedDate = DateTime.now();
  String title = 'Chọn ngày';

  bool _decideWhichDayToEnable(DateTime day) {
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
    if (picked != null)
      setState(() {
        selectedDate = picked;
        title = formatDate(selectedDate, [dd, '-', mm, '-', yyyy]);
        appointmentDate = formatDate(selectedDate, [yyyy, '-', mm, '-', dd]);
      });
  }
}
