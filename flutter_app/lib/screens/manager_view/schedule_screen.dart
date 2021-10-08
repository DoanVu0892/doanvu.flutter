import 'package:flutter/material.dart';
import 'package:flutter_app/customs/themes.dart';

class ScheduleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/pageOne', arguments: 'Dentist');
          },
        ),
        title: Text('titleDentist'),
        backgroundColor: CustomTheme.colorEnd,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: CustomTheme.primaryGradient,
        ),
        child: Text(''),
      ),
    );
  }
}
