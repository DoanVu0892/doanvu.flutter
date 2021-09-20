import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

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
            title: Center(
                child: Text(
              title,
              style: titleStyle,
            )),
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

class Utils {
  static void gotoLogin(BuildContext context) async {
    final _isLogin = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => AlertDialog(
        title: Center(
            child: Text(
          'Cảnh báo',
          style: TextStyle(color: Colors.redAccent),
        )),
        content: Container(
          alignment: Alignment.center,
          height: 40,
          child: Center(
              child: Text(
            'Phiên đăng nhập đã hết hạn\n Bạn cần đăng nhập lại!',
            textAlign: TextAlign.center,
          )),
        ),
        actions: [
          FlatButton(
            child: Text(
              'Đồng ý',
              style: TextStyle(color: Colors.redAccent),
            ),
            onPressed: () => {
              Navigator.pop(context, true),
            },
          ),
        ],
      ),
    );
    if (_isLogin) {
      Navigator.popAndPushNamed(context, '/login');
    }
  }

  static void showToast(
      String title, String msg, bool success, VoidCallback dismiss) {
    showToastWidget(
      Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          height: 140,
          width: 250,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 15,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      success ? Icons.done : Icons.warning_amber_outlined,
                      color: success ? Colors.green : Colors.red,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    msg,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      duration: Duration(seconds: 3),
      onDismiss: dismiss != null ? dismiss : () {},
    );
  }
}
