import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/blocs/notify_bloc.dart';
import 'package:flutter_app/customs/custom_circular_progress.dart';
import 'package:flutter_app/customs/themes.dart';
import 'package:flutter_app/events/notify_event.dart';
import 'package:flutter_app/models/notify.dart';
import 'package:flutter_app/states/notify_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotifyCustomerView extends StatefulWidget {
  @override
  _NotifyCustomerViewState createState() => _NotifyCustomerViewState();
}

class _NotifyCustomerViewState extends State<NotifyCustomerView> {
  List<Notify> dataNotify = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocConsumer<NotifyBloc, NotifyState>(
        listener: (context, state) {
          if (state is NotifyCMStateSuccess) {
            setState(() {
              dataNotify = state.response.dataNotify;
            });
          }
        },
        builder: (context, state) {
          if (state is NotifyStateLoading) {
            return Center(
              child: CircularProgress(),
            );
          }

          if (state is NotifyCMStateSuccess) {
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
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.blueAccent),
                                child: Icon(
                                  Icons.notifications,
                                  color: Colors.white,
                                )),
                            Container(
                              width: 300,
                              margin: EdgeInsets.only(left: 10, right: 10),
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
    );
  }
}
