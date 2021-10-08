import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/customs/themes.dart';

class AddUserManager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Container(
          margin: EdgeInsets.only(left: 10),
          child: InkWell(
            onTap: () async {
              Navigator.pop(context, false);
            },
            child: Container(
                width: 60,
                height: 30,
                child: Center(child: Icon(Icons.arrow_back_ios))),
          ),
        ),
        title: Center(
          child: Container(
            margin: EdgeInsets.only(right: 40),
            child: Text(
              'Thêm nha sỹ',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        backgroundColor: CustomTheme.colorEnd,
      ),
      body: null,
    );
  }
}
