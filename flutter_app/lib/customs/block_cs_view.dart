import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/blocs/patient_bloc.dart';
import 'package:flutter_app/blocs/schedule_bloc.dart';
import 'package:flutter_app/customs/utils.dart';
import 'package:flutter_app/events/patient_event.dart';
import 'package:flutter_app/events/schedule_event.dart';
import 'package:flutter_app/models/dentist.dart';
import 'package:flutter_app/models/patient.dart';
import 'package:flutter_app/models/schedule.dart';
import 'package:flutter_app/states/patient_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

import 'custom_circular_progress.dart';

// ignore: must_be_immutable
class BlockCSItem extends StatefulWidget {
  final Schedule schedule;
  final String dentistId;
  final String appointmentDate;
  final String patientName;
  final String patientId;

  BlockCSItem({
    this.schedule,
    this.dentistId,
    this.appointmentDate,
    this.patientId,
    this.patientName,
  }) : assert(dentistId != null);

  @override
  _BlockCSItemState createState() => _BlockCSItemState();
}

class _BlockCSItemState extends State<BlockCSItem> {
  Color colorItem;

  String title;

  List<Patient> patientList = [];

  Patient _patient;
  TextEditingController noteController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.schedule.booked == 'booked') {
      colorItem = Colors.red;
      title = 'Đã đặt\n${widget.schedule.block.patientName}';
    } else if (widget.schedule.booked == 'available') {
      colorItem = Colors.green;
      title = 'Thời gian: ${widget.schedule.time}';
    } else if (widget.schedule.booked == 'none') {
      colorItem = Colors.grey;
      title = 'Thời gian: ${widget.schedule.time} \nNghỉ khám';
    }

    return GestureDetector(
        child: Container(
          alignment: Alignment.centerLeft,
          child: Center(
            child: Text(
              title,
              style: TextStyle(fontSize: 18, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          decoration: BoxDecoration(
              color: colorItem, borderRadius: BorderRadius.circular(8.0)),
        ),
        onTap: () => (widget.schedule.booked == 'available')
            ? {
                print('note: ${widget.schedule.block.note}'),
                DialogUtils.showCustomDialog(context,
                    okBtnText: 'Đặt lịch',
                    title: 'Đặt lịch ${widget.schedule.time}',
                    child: TextField(
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Nhập ghi chú',
                        labelText: 'Ghi chú',
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      controller: noteController,
                    ),
                    okBtnFunction: () => {
                          print(
                              'textNote: ${noteController.text} -patientId: ${widget.patientId} -patientName: ${widget.patientName} -dentistId: ${widget.dentistId} -appointmentDate: ${widget.appointmentDate} -blockId: ${widget.schedule.blockId}'),
                          BlocProvider.of<ScheduleBloc>(context).add(
                              ScheduleAddEventRequested(
                                  patientId: widget.patientId,
                                  patientName: widget.patientName,
                                  dentistId: widget.dentistId,
                                  appointmentDate: widget.appointmentDate,
                                  note: noteController.text,
                                  blockId: widget.schedule.blockId)),
                          Navigator.of(context).pop(),
                        }),
                setState(() {
                  print('changeState');
                  colorItem = Colors.blue;
                }),
              }
            : {
                (widget.schedule.booked == 'booked')
                    ? {
                        print('note: ${widget.schedule.block.note}'),
                        DialogUtils.showCustomDialog(context,
                            okBtnText: 'Hủy lịch',
                            title: 'Hủy lịch ${widget.schedule.time}',
                            child: TextField(
                              maxLines: null,
                              decoration: InputDecoration(
                                hintText: 'Nhập ghi chú',
                                labelText: 'Ghi chú',
                                border: OutlineInputBorder(),
                                labelStyle: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              controller: noteController,
                            ),
                            okBtnFunction: () => {
                                  print('state: ${widget.schedule.block.id}'),
                                  BlocProvider.of<ScheduleBloc>(context).add(
                                      ScheduleDelEventRequested(
                                          bookedId: widget.schedule.block.id,
                                          reason: noteController.text)),
                                  Navigator.of(context).pop(),
                                }),
                      }
                    : {
                        print(widget.schedule.booked),
                      }
              });
  }
}