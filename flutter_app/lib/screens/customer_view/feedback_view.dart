import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/blocs/feedback_bloc.dart';
import 'package:flutter_app/customs/custom_circular_progress.dart';
import 'package:flutter_app/customs/snackbar.dart';
import 'package:flutter_app/customs/themes.dart';
import 'package:flutter_app/events/feedback_event.dart';
import 'package:flutter_app/models/user.dart';
import 'package:flutter_app/states/feedback_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedBackView extends StatefulWidget {
  final User patient;
  FeedBackView({this.patient}) : assert(patient != null);
  @override
  _FeedBackViewState createState() => _FeedBackViewState();
}

class _FeedBackViewState extends State<FeedBackView> {
  TextEditingController myTitleController = TextEditingController();

  TextEditingController myContentController = TextEditingController();

  FocusNode focusTitle = FocusNode();

  FocusNode focusContent = FocusNode();

  @override
  Widget build(BuildContext context) {
    print('user: ${widget.patient.id}');

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: BlocConsumer<FeedBackBloc, FeedBackState>(
        listener: (context, state) {
          if (state is FeedBackAddStateSuccess) {
            _showSnackBar('Gửi góp ý thành công', true);
          }

          if (state is FeedBackStateFailure) {
            _showSnackBar('Gửi góp ý lỗi', false);
          }
        },
        builder: (context, state) {
          if (state is FeedBackStateLoading) {
            return Center(
              child: CircularProgress(),
            );
          }

          return Container(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.all(10),
                        child: Text(
                          'Tiêu đề',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        )),
                    Card(
                      child: Container(
                        margin: EdgeInsets.only(left: 15, right: 15),
                        child: TextField(
                          focusNode: focusTitle,
                          controller: myTitleController,
                          style: const TextStyle(
                              fontFamily: 'WorkSansSemiBold',
                              fontSize: 20.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Nhập tiêu đề',
                            hintStyle: const TextStyle(
                                fontFamily: 'WorkSansSemiBold', fontSize: 17.0),
                          ),
                          textInputAction: TextInputAction.go,
                        ),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.all(10),
                        child: Text(
                          'Tiêu đề',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        )),
                    Card(
                      child: Container(
                        height: 150,
                        margin: EdgeInsets.only(left: 15, right: 15),
                        child: TextField(
                          maxLines: 6,
                          focusNode: focusContent,
                          controller: myContentController,
                          style: const TextStyle(
                              fontFamily: 'WorkSansSemiBold',
                              fontSize: 20.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Nhập tiêu đề',
                            hintStyle: const TextStyle(
                                fontFamily: 'WorkSansSemiBold', fontSize: 17.0),
                          ),
                          textInputAction: TextInputAction.go,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: CustomTheme.loginGradientStart,
                            offset: Offset(1.0, 6.0),
                            blurRadius: 20.0,
                          ),
                          BoxShadow(
                            color: CustomTheme.loginGradientEnd,
                            offset: Offset(1.0, 6.0),
                            blurRadius: 20.0,
                          ),
                        ],
                        gradient: LinearGradient(
                            colors: <Color>[
                              CustomTheme.loginGradientEnd,
                              CustomTheme.loginGradientStart
                            ],
                            begin: FractionalOffset(0.2, 0.2),
                            end: FractionalOffset(1.0, 1.0),
                            stops: <double>[0.0, 1.0],
                            tileMode: TileMode.clamp),
                      ),
                      child: MaterialButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 42.0),
                            child: Text(
                              'Gửi góp ý',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25.0,
                                  fontFamily: 'WorkSansBold'),
                            ),
                          ),
                          onPressed: () {
                            if (myTitleController.text != null &&
                                myTitleController.text != '' &&
                                myContentController.text != null &&
                                myContentController.text != '') {
                              BlocProvider.of<FeedBackBloc>(context).add(
                                  FeedbackAddEventRequested(
                                      patientId: widget.patient.id,
                                      patientName: widget.patient.name,
                                      title: myTitleController.text,
                                      content: myContentController.text));
                            } else {
                              _showSnackBar(
                                  'Vui lòng điền đầy đủ thông tin', false);
                            }
                          }),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showSnackBar(String msg, bool success) {
    CustomSnackBar(
        context,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              success ? Icons.done : Icons.warning_amber_outlined,
              color: success ? Colors.green : Colors.red,
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              msg,
              style: TextStyle(
                  color: success ? Colors.green : Colors.red, fontSize: 18),
            )
          ],
        ));
  }
}
