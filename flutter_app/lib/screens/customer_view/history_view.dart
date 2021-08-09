import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/blocs/history_bloc.dart';
import 'package:flutter_app/customs/custom_circular_progress.dart';
import 'package:flutter_app/customs/snackbar.dart';
import 'package:flutter_app/customs/themes.dart';
import 'package:flutter_app/events/history_event.dart';
import 'package:flutter_app/models/history_response.dart';
import 'package:flutter_app/states/history_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryView extends StatefulWidget {
  final int patientId;
  const HistoryView({this.patientId});
  @override
  _HistoryViewState createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  List<History> dataHistory = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocConsumer<HistoryBloc, HistoryState>(
        listener: (context, state) {
          if (state is HistoryStateSuccess) {
            setState(() {
              print('his: ${state.response.message}');
              dataHistory = state.response.dataHistory;
            });
          }
          if(state is HistoryStateFailure){
            _showSnackBar("get Schedule failure", false);
          }
        },
        builder: (context, state) {
          if (state is HistoryStateLoading) {
            return CircularProgress();
          }

          if (state is HistoryStateFailure) {
            return Center(
              child:Container(
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
                    'bấm để lấy thông tin',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontFamily: 'WorkSansBold'),
                  ),
                  onPressed: () {
                    BlocProvider.of<HistoryBloc>(context)
                        .add(HistoryEventRequested(patientId: widget.patientId));
                  },
                ),
              ),
            );
          }

          if (state is HistoryStateSuccess) {
            return Container(
              margin: EdgeInsets.all(10),
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: false,
                  itemCount: dataHistory.length,
                  itemBuilder: (context, index) {
                    final history = dataHistory[index];
                    return Card(
                      child: ListTile(
                        leading: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.blueAccent),
                            child: Icon(
                              Icons.info,
                              color: Colors.white,
                            )),
                        title: Text(
                            'Thời gian: ${formatDate(DateTime.parse(history.appointmentDate), [
                              yyyy,
                              '-',
                              mm,
                              '-',
                              dd
                            ])} : ${history.time} '),
                        subtitle: Text(
                            'Trạng thái: ${history.status == 1 ? 'Đã đặt' : 'Đã hủy, lí do: ${history.reason}'}'),
                        onTap: () {},
                      ),
                    );
                  }),
            );
          }

          return Center(
            // child: InkWell(
            //   child: Text('bấm để lấy thông tin'),
            //   onTap: () {
            //     BlocProvider.of<HistoryBloc>(context)
            //         .add(HistoryEventRequested(patientId: widget.patientId));
            //   },
            // ),
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
                    'bấm để lấy thông tin',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontFamily: 'WorkSansBold'),
                  ),
                  onPressed: () {
                    BlocProvider.of<HistoryBloc>(context)
                            .add(HistoryEventRequested(patientId: widget.patientId));
                  },
                ),
              ),
          );
        },
      ),
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
}
