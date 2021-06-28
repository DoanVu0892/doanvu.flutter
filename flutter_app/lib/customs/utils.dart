import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogUtils {
  static DialogUtils _instance = new DialogUtils.internal();

  DialogUtils.internal();

  factory DialogUtils() => _instance;

  static bool showCustomDialog(BuildContext context,
      {@required String title,
      @required TextStyle titleStyle,
      @required Widget child,
      @required String okBtnText,
      String cancelBtnText = "Hủy",
      @required Function okBtnFunction}) {
    bool test = false;
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            insetPadding: EdgeInsets.all(10),
            title: Center(child: Text(title, style: titleStyle,)),
            content: child,
            actions: <Widget>[
              // ignore: deprecated_member_use
              FlatButton(
                  child: Text(
                    cancelBtnText,
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  ),
                  onPressed: () => Navigator.pop(context)),
              // ignore: deprecated_member_use
              FlatButton(
                child: Text(
                  okBtnText,
                  style: TextStyle(fontSize: 18, color: Colors.blueAccent),
                ),
                onPressed: okBtnFunction,
              ),
            ],
          );
        }).then((value) => {
          test = value,
        });
    return test;
  }
}
