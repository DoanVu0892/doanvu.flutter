import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CircularProgress extends StatelessWidget {
  final Color background;
  CircularProgress({this.background});
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      width: 100.0,
      height: 100.0,
      decoration: ShapeDecoration(
        color: background != null ? background : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
      ),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
      ),
    ));
  }
}
