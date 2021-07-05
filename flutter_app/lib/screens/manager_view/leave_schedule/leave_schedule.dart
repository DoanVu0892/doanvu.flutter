import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LeaveScheduleView extends StatefulWidget {
  @override
  _LeaveScheduleViewState createState() => _LeaveScheduleViewState();
}

class _LeaveScheduleViewState extends State<LeaveScheduleView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cài lịch nghỉ"),
      ),
      body: Center(
        child: Text("cái gì gì đấy"),
      ),
    );
  }
}