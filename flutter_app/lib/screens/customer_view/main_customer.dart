import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/blocs/history_bloc.dart';
import 'package:flutter_app/blocs/schedule_bloc.dart';
import 'package:flutter_app/customs/themes.dart';
import 'package:flutter_app/events/history_event.dart';
import 'package:flutter_app/events/schedule_event.dart';
import 'package:flutter_app/models/user.dart';
import 'package:flutter_app/screens/customer_view/book_view.dart';
import 'package:flutter_app/screens/customer_view/history_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This is the stateful widget that the main application instantiates.
class MainCustomerScreen extends StatefulWidget {
  final User user;
  const MainCustomerScreen({Key key, this.user}) : assert(user != null), super(key: key);

  @override
  State<MainCustomerScreen> createState() => _MainCustomerScreenState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MainCustomerScreenState extends State<MainCustomerScreen> {
  int _selectedIndex = 0;
  String title = 'Đặt lịch';

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      title = _selectedIndex == 0 ? 'Đặt lịch' : 'Lịch sử';
    });
  }

  Widget getBody( )  {
    if(this._selectedIndex == 0) {
      BlocProvider.of<ScheduleBloc>(context).add(
          ScheduleEventRequested(
              dentistId: widget.user.dentistId,
              appointmentDate: formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]),
              workShift: '1'));

      return BookView(user: widget.user);
    } else if(this._selectedIndex==1) {
      BlocProvider.of<HistoryBloc>(context).add(
        HistoryEventRequested(patientId: widget.user.id)
      );

      return HistoryView(patientId: widget.user.id,);
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
                    height: 20,
                    child: Center(child: Text('Bạn muốn đăng xuất?'))),
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
                margin: EdgeInsets.only(right: 40),
                child: Text(
                  title,
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
            child: this.getBody(),
          ),
          bottomNavigationBar: BottomNavigationBar(
            iconSize: 30,
            selectedIconTheme: IconThemeData (
                // color: CustomTheme.loginGradientEnd,
                opacity: 1.0,
                size: 35
            ),
            unselectedIconTheme: IconThemeData (
                // color: Colors.black45,
                opacity: 0.5,
                size: 25
            ),
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.access_time),
                label: 'Đặt lịch',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history),
                label: 'Lịch sử',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.amber[800],
            onTap: _onItemTapped,
          ),
        )
    );
  }
}