import 'package:flutter/material.dart';
import 'package:flutter_app/customs/themes.dart';
import 'package:flutter_app/models/feedback.dart';

class FeedBackDetailView extends StatefulWidget {
  FeedBack feedback;

  FeedBackDetailView({
    this.feedback,
  });

  @override
  _FeedBackDetailViewState createState() => _FeedBackDetailViewState();
}

class _FeedBackDetailViewState extends State<FeedBackDetailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Container(
            margin: EdgeInsets.only(right: 50),
            child: Text(
              'Phản hồi khác hàng',
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
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: CustomTheme.primaryGradient,
        ),
        // child: SingleChildScrollView(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                        'Nội dung',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    )),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  alignment: Alignment.topLeft,
                  child: Text(
                    '${widget.feedback.content}',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: CustomTheme.colorStart,
                        offset: Offset(1.0, 6.0),
                        blurRadius: 20.0,
                      ),
                      BoxShadow(
                        color: CustomTheme.colorEnd,
                        offset: Offset(1.0, 6.0),
                        blurRadius: 20.0,
                      ),
                    ],
                    gradient: CustomTheme.primaryGradient,
                  ),
                ),
              ],
            ),
          ),
        ),
        // ),
      ),
    );
  }
}
