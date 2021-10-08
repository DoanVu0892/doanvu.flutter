import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/blocs/notify_bloc.dart';
import 'package:flutter_app/customs/custom_circular_progress.dart';
import 'package:flutter_app/customs/themes.dart';
import 'package:flutter_app/customs/utils.dart';
import 'package:flutter_app/events/notify_event.dart';
import 'package:flutter_app/models/notify.dart';
import 'package:flutter_app/states/notify_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotifyManagerView extends StatefulWidget {
  @override
  _NotifyManagerViewState createState() => _NotifyManagerViewState();
}

class _NotifyManagerViewState extends State<NotifyManagerView> {
  List<Notify> dataNotify = [];

  @override
  Widget build(BuildContext context) {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
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
              'Thông báo',
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
        child: BlocConsumer<NotifyBloc, NotifyState>(
          listener: (context, state) {
            if (state is NotifyStateSuccess) {
              setState(() {
                dataNotify = state.response.dataNotify;
              });
            }
            if (state is NotifyStateLogout) {
              // Navigator.popAndPushNamed(context, '/login');
              Utils.gotoLogin(context);
            }
          },
          builder: (context, state) {
            if (state is NotifyStateLoading) {
              return Center(
                child: CircularProgress(),
              );
            }

            if (state is NotifyStateSuccess) {
              return Container(
                margin: EdgeInsets.all(10),
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: false,
                    itemCount: dataNotify.length,
                    itemBuilder: (context, index) {
                      final notify = dataNotify[index];
                      return Card(
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: Row(
                            children: <Widget>[
                              Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: Colors.blueAccent),
                                  child: Icon(
                                    Icons.notifications,
                                    color: Colors.white,
                                  )),
                              Container(
                                width:
                                    data.size.shortestSide <= 375 ? 260 : 300,
                                margin: EdgeInsets.only(left: 5, right: 5),
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      '${notify.title}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '${notify.message}',
                                      style: TextStyle(fontSize: 16),
                                      maxLines: 3,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      '${notify.date} ${notify.time}',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }),
              );
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
                    'Bấm để lấy thông báo',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontFamily: 'WorkSansBold'),
                  ),
                  onPressed: () {
                    BlocProvider.of<NotifyBloc>(context)
                        .add(NotifyManagerEventRequested());
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
