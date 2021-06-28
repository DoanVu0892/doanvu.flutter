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
class BlockItem extends StatefulWidget {
  final Schedule schedule;
  final DentistData dentistData;
  final String appointmentDate;

  BlockItem(
      {this.schedule,
      this.dentistData,
      this.appointmentDate,})
      : assert(dentistData != null);

  @override
  _BlockItemState createState() => _BlockItemState();
}

class _BlockItemState extends State<BlockItem> {
  Color colorItem;

  String title;

  List<Patient> patientList = [];

  Patient _patient;
  TextEditingController noteController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.schedule.booked == 'booked') {
      colorItem = Colors.red;
      title = widget.schedule.block.note;
    } else if (widget.schedule.booked == 'available') {
      colorItem = Colors.green;
      title = 'Thời gian: ${widget.schedule.time}';
    } else if (widget.schedule.booked == 'none') {
      colorItem = Colors.grey;
      title = 'Thời gian: ${widget.schedule.time} \nNghỉ khám';
    }

    return GestureDetector(
        child: Container(
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
                DialogUtils.showCustomDialog(context,
                    okBtnText: 'Đặt lịch',
                    title: 'Đặt lịch ${widget.schedule.time}',
                    child: BlocConsumer<PatientBloc, PatientState>(
                      listener: (context, state) {
                        if (state is PatientStateSuccess) {
                          setState(() {
                            patientList = state.response.data;
                          });
                        }
                      },
                      builder: (context, state) {
                        if (state is PatientStateLoading) {
                          return CircularProgress();
                        }
                        return Container(
                          width: (MediaQuery.of(context).size.width - 100),
                          height: 180,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                // flex: 1,
                                child: SearchableDropdown<Patient>(
                                  isCaseSensitiveSearch: true,
                                  isExpanded: true,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey.shade900,
                                      fontWeight: FontWeight.w400),
                                  hint: Text(
                                    "Chọn bệnh nhân",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey.shade900,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  value: _patient,
                                  items: patientList.map((Patient patient) {
                                    return DropdownMenuItem<Patient>(
                                      value: patient,
                                      child: Container(
                                        color: Colors.transparent,
                                        child: new Text(patient.name),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (data) {
                                    print('value $data');
                                    setState(() {
                                      this._patient = data;
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: TextField(
                                  maxLines: null,
                                  decoration: InputDecoration(
                                    hintText: 'Nhập ghi chú',
                                    labelText: 'Ghi chú',
                                    border: OutlineInputBorder(),
                                    labelStyle: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  controller: noteController,
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                    okBtnFunction: () => {
                          print(
                              'textNote: ${noteController.text} -patientId: ${_patient.id} -patientName: ${_patient.name} -dentistId: ${widget.dentistData.id} -appointmentDate: ${widget.appointmentDate} -blockId: ${widget.schedule.blockId}'),
                          BlocProvider.of<ScheduleBloc>(context).add(
                              ScheduleAddEventRequested(
                                  patientId: _patient.id,
                                  patientName: _patient.name,
                                  dentistId: widget.dentistData.id,
                                  appointmentDate: widget.appointmentDate,
                                  note: noteController.text,
                                  blockId: widget.schedule.blockId)),
                          Navigator.of(context).pop(),
                        }),
                setState(() {
                  print('changeState');
                  colorItem = Colors.blue;
                }),
                BlocProvider.of<PatientBloc>(context).add(
                    PatientEventRequested(dentistId: widget.dentistData.id)),
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
                        print('abc'),
                      }
              });
  }
}
