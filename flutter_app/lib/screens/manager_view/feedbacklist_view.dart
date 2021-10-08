import 'package:flutter/material.dart';
import 'package:flutter_app/blocs/feedback_bloc.dart';
import 'package:flutter_app/customs/custom_circular_progress.dart';
import 'package:flutter_app/customs/snackbar.dart';
import 'package:flutter_app/customs/themes.dart';
import 'package:flutter_app/customs/utils.dart';
import 'package:flutter_app/events/feedback_event.dart';
import 'package:flutter_app/screens/manager_view/fb_details_view.dart';
import 'package:flutter_app/states/feedback_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedBackListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomTheme.colorEnd,
        title: Center(
          child: Container(
            margin: EdgeInsets.only(right: 50),
            child: Text(
              'Phản hồi khách hàng',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(bottom: 20),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: CustomTheme.primaryGradient,
        ),
        child: BlocConsumer<FeedBackBloc, FeedBackState>(
            builder: (context, state) {
          if (state is FeedBackStateLoading) {
            return Center(
              child: CircularProgress(),
            );
          }
          if (state is FeedBackStateSuccess) {
            print(state.responseFeedback.feedBacks);
            final feedbacks = state.responseFeedback.feedBacks;
            return Container(
              margin: EdgeInsets.all(10),
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: false,
                  itemCount: feedbacks.length,
                  itemBuilder: (context, index) {
                    final feedback = feedbacks[index];
                    return InkWell(
                      child: Card(
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: Row(
                            children: <Widget>[
                              Container(
                                width:
                                    data.size.shortestSide <= 375 ? 250 : 300,
                                margin: EdgeInsets.only(left: 10, right: 10),
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Tiêu đề: ${feedback.title}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'ID KH: ${feedback.patientId}',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    // Text(
                                    //   'Nội dung: ${feedback.content}',
                                    //   style: TextStyle(fontSize: 16),
                                    //   maxLines: 3,
                                    // ),
                                    // SizedBox(
                                    //   height: 10,
                                    // ),
                                    Text(
                                      'Thời gian: ${feedback.date} ${feedback.time}',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        print('test');
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => FeedBackDetailView(
                                  feedback: feedback,
                                )));
                      },
                    );
                  }),
            );
          }

          if (state is FeedBackStateFailure) {
            return Center(
              child: MaterialButton(
                child: Text(
                  'Bấm, để lấy phản hồi',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                onPressed: () {
                  BlocProvider.of<FeedBackBloc>(context)
                      .add(FeedbackEventRequested());
                },
              ),
            );
          }
          return Center(
            child: MaterialButton(
              child: Text(
                'Bấm, để lấy phản hồi',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onPressed: () {
                BlocProvider.of<FeedBackBloc>(context)
                    .add(FeedbackEventRequested());
              },
            ),
          );
        }, listener: (context, state) {
          if (state is FeedBackStateSuccess) {
          } else if (state is FeedBackStateLogout) {
            // Navigator.popAndPushNamed(context, '/login');
            Utils.gotoLogin(context);
          } else {
            _showSnackBar(context, 'Lấy phản hồi lỗi', false);
          }
        }),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String msg, bool success) {
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
