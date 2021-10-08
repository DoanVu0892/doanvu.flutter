import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/blocs/history_bloc.dart';
import 'package:flutter_app/blocs/notify_bloc.dart';
import 'package:flutter_app/blocs/schedule_bloc.dart';
import 'package:flutter_app/customs/themes.dart';
import 'package:flutter_app/events/history_event.dart';
import 'package:flutter_app/events/notify_event.dart';
import 'package:flutter_app/events/schedule_event.dart';
import 'package:flutter_app/models/user.dart';
import 'package:flutter_app/repositories/app_repository.dart';
import 'package:flutter_app/screens/customer_view/book_view.dart';
import 'package:flutter_app/screens/customer_view/feedback_view.dart';
import 'package:flutter_app/screens/customer_view/history_view.dart';
import 'package:flutter_app/screens/customer_view/notify_customer_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This is the stateful widget that the main application instantiates.
class MainCustomerScreen extends StatefulWidget {
  final User user;
  final AppRepository appRepository;
  const MainCustomerScreen({Key key, this.user, this.appRepository})
      : assert(user != null),
        super(key: key);

  @override
  State<MainCustomerScreen> createState() => _MainCustomerScreenState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MainCustomerScreenState extends State<MainCustomerScreen>
    with WidgetsBindingObserver {
  int _selectedIndex = 0;
  String title = 'Đặt lịch';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
      print('call checkLogin API');
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

  void _onItemTapped(int index) {
    print('onTapItem');
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        title = 'Đặt lịch';
      } else if (_selectedIndex == 1) {
        title = 'Lịch sử';
      } else if (_selectedIndex == 2) {
        title = 'Thông báo';
      } else if (_selectedIndex == 3) {
        title = 'Góp ý';
      }
    });
  }

  Widget getBody() {
    if (this._selectedIndex == 0) {
      return BookView(user: widget.user);
    } else if (this._selectedIndex == 1) {
      BlocProvider.of<HistoryBloc>(context)
          .add(HistoryEventRequested(patientId: widget.user.id));

      return HistoryView(
        patientId: widget.user.id,
      );
    } else if (this._selectedIndex == 2) {
      BlocProvider.of<NotifyBloc>(context)
          .add(NotifyEventRequested(patientId: widget.user.id));
      return NotifyCustomerView();
    } else if (this._selectedIndex == 3) {
      print(widget.user);
      return FeedBackView(
        patient: widget.user,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print('check run');
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
              backgroundColor: CustomTheme.colorEnd),
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              gradient: CustomTheme.primaryGradient,
            ),
            child: this.getBody(),
          ),
          bottomNavigationBar: BottomNavigationBar(
            iconSize: 30,
            selectedIconTheme: IconThemeData(opacity: 1.0, size: 35),
            unselectedIconTheme: IconThemeData(opacity: 0.5, size: 25),
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.access_time),
                label: 'Đặt lịch',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history),
                label: 'Lịch sử',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications_active),
                label: 'Thông báo',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.report),
                label: 'Góp ý',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.amber[800],
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
            onTap: _onItemTapped,
          ),
        ));
  }
}
