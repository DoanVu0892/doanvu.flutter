import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/blocs/patient_bloc.dart';
import 'package:flutter_app/customs/custom_circular_progress.dart';
import 'package:flutter_app/states/patient_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PatientScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient'),
      ),
      body: BlocConsumer<PatientBloc, PatientState>(
        listener: (context, state){
          if(state is PatientStateSuccess){
            print('state: ${state.response.message}');
          }
        },
        builder: (context, state){
          if(state is PatientStateLoading){
            return CircularProgress();
          }
          return Text('');
        },
      ),
    );
  }
}