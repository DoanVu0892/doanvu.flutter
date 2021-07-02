import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/blocs/history_bloc.dart';
import 'package:flutter_app/customs/custom_circular_progress.dart';
import 'package:flutter_app/customs/themes.dart';
import 'package:flutter_app/events/history_event.dart';
import 'package:flutter_app/models/history_response.dart';
import 'package:flutter_app/states/history_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryView extends StatefulWidget{
  final String patientId;
  const HistoryView({this.patientId});
  @override
  _HistoryViewState createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  List<History>dataHistory = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocConsumer<HistoryBloc, HistoryState>(
        listener: (context, state){
          if(state is HistoryStateSuccess){
            setState(() {
              print('his: ${state.response.message}');
              dataHistory = state.response.dataHistory;
            });
          }
        },
        builder: (context, state){
          if(state is HistoryStateLoading){
            return CircularProgress();
          }

          if(state is HistoryStateFailure){
            return Center(
              child: InkWell(
                child: Text('Lấy lịch sử bị lỗi!!!\n bấm để thử lại'),
                onTap: (){
                  BlocProvider.of<HistoryBloc>(context).add(
                      HistoryEventRequested(patientId: widget.patientId)
                  );
                },
              ),
            );
          }

          if(state is HistoryStateSuccess){
            return Container(
                margin: EdgeInsets.all(10),
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: false,
                      itemCount: dataHistory.length,
                      itemBuilder:(context, index){
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
                            title: Text('Thời gian: ${formatDate(DateTime.parse(history.appointmentDate), [yyyy, '-', mm, '-', dd])} : ${history.time} '),
                            subtitle: Text('Trạng thái: ${history.status ==1 ? 'Đã khám': 'Đã hủy, lí do: ${history.reason}'}'),
                            onTap: () {},
                          ),
                        );
                      }
                  ),
            );
          }

          return Center(
            child: InkWell(
              child: Text('bấm để lấy thông tin'),
              onTap: (){
                BlocProvider.of<HistoryBloc>(context).add(
                    HistoryEventRequested(patientId: widget.patientId)
                );
              },
            ),
          );
        },
      ),
    );
  }
}