import 'package:flutter/material.dart';
import 'package:flutter_app/blocs/dentist_bloc.dart';
import 'package:flutter_app/customs/custom_circular_progress.dart';
import 'package:flutter_app/customs/snackbar.dart';
import 'package:flutter_app/customs/themes.dart';
import 'package:flutter_app/customs/utils.dart';
import 'package:flutter_app/events/dentist_event.dart';
import 'package:flutter_app/models/dentist.dart';
import 'package:flutter_app/screens/manager_view/add_screen/add_dentist.dart';
import 'package:flutter_app/states/clinic_state.dart';
import 'package:flutter_app/states/dentist_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class DentistScreen extends StatefulWidget {
  final int clinicId;

  DentistScreen({@required this.clinicId}) : assert(clinicId != null);

  @override
  _DentistScreenState createState() => _DentistScreenState();
}

class _DentistScreenState extends State<DentistScreen> {
  List<DentistData> dentistList = [];
  bool shouldUpdate = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  FocusNode nameFocus = FocusNode();
  FocusNode phoneFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Container(
          margin: EdgeInsets.only(left: 10),
          child: InkWell(
            onTap: () async {
              Navigator.pop(context, true);
            },
            child: Container(
                width: 60,
                height: 30,
                child: Center(child: Icon(Icons.arrow_back_ios))),
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: InkWell(
              onTap: () async {
                final shouldUpdate2 =
                    await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AddDentistScreen(
                              clinicId: widget.clinicId,
                            )));
                setState(() {
                  this.shouldUpdate = shouldUpdate2;
                  if (shouldUpdate) {
                    BlocProvider.of<DentistBloc>(context).add(
                      DentistEventRequested(),
                    );
                  }
                });
              },
              child: Container(
                  width: 60,
                  height: 30,
                  child: Center(
                      child: Icon(
                    Icons.add,
                    size: 35,
                  ))),
            ),
          )
        ],
        backgroundColor: CustomTheme.colorEnd,
        title: Center(
          child: Container(
            child: Text(
              'Qu???n l?? nha s???',
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
        child: BlocConsumer<DentistBloc, DentistState>(
          listener: (context, state) {
            if (state is DentistStateSuccess) {
              setState(() {
                dentistList = state.response.dataList;
              });
              // print('dentist: ${dentistList.first.name}');
              if (shouldUpdate) {
                setState(() {
                  shouldUpdate = false;
                });
                _showSnackBar('Th??m nha s??? th??nh c??ng', true);
              }
            } else if (state is DentistEditStateSuccess) {
              BlocProvider.of<DentistBloc>(context).add(
                DentistEventRequested(),
              );
              _showSnackBar('S???a nha s??? th??nh c??ng', true);
            } else if (state is DentistDelStateSuccess) {
              BlocProvider.of<DentistBloc>(context).add(
                DentistEventRequested(),
              );
              _showSnackBar('X??a nha s??? th??nh c??ng', true);
            } else if (state is DentistStateLogout) {
              // Navigator.popAndPushNamed(context, '/login');
              Utils.gotoLogin(context);
            }
          },
          builder: (context, state) {
            if (state is DentistStateLoading) {
              return CircularProgress();
            }

            if (state is DentistStateSuccess ||
                state is DentistEditStateSuccess ||
                state is DentistDelStateSuccess) {
              return Container(
                margin: EdgeInsets.all(10),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: dentistList.length,
                  itemBuilder: (context, index) {
                    final dentist = dentistList[index];
                    return Card(
                      child: Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 1 / 5,
                        child: ListTile(
                          leading: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: CustomTheme.colorEnd),
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                              )),
                          title: Text(dentist.name),
                          subtitle: Text(dentist.phone),
                          onTap: () {},
                        ),
                        secondaryActions: <Widget>[
                          new IconSlideAction(
                            caption: 'S???a',
                            color: Colors.black45,
                            icon: Icons.edit,
                            onTap: () => {
                              nameController.text = dentist.name,
                              phoneController.text = dentist.phone,
                              DialogUtils.showCustomDialog(context,
                                  title: 'S???a th??ng tin dentist',
                                  child: GestureDetector(
                                    onTap: () {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                    },
                                    child: Container(
                                      height: 200,
                                      width: 300,
                                      padding: EdgeInsets.all(5),
                                      child: Column(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              child: Column(
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        bottom: 5),
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      'T??n nha s???',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18),
                                                    ),
                                                  ),
                                                  TextField(
                                                    maxLines: 1,
                                                    decoration: InputDecoration(
                                                      hintText: dentist.name,
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelStyle: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    controller: nameController,
                                                    focusNode: nameFocus,
                                                    onSubmitted: (_) {
                                                      phoneFocus.requestFocus();
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              child: Column(
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        bottom: 5, top: 5),
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      'S??? ??i???n tho???i',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18),
                                                    ),
                                                  ),
                                                  TextField(
                                                    maxLines: 1,
                                                    keyboardType:
                                                        TextInputType.phone,
                                                    decoration: InputDecoration(
                                                      hintText: dentist.phone,
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelStyle: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    controller: phoneController,
                                                    focusNode: phoneFocus,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  okBtnText: 'L??u', okBtnFunction: () {
                                BlocProvider.of<DentistBloc>(context)
                                    .add(DentistEditEventRequested(
                                  dentistId: dentist.id,
                                  name: nameController.text,
                                  phone: phoneController.text,
                                ));
                                Navigator.of(context).pop();
                              }, titleStyle: null)
                            },
                          ),
                          new IconSlideAction(
                            caption: 'X??a',
                            color: Colors.red,
                            icon: Icons.delete,
                            onTap: () => {
                              print('onDel'),
                              DialogUtils.showCustomDialog(context,
                                  title: 'C???nh b??o',
                                  titleStyle: TextStyle(color: Colors.red),
                                  child: Text(
                                    'B???n mu???n x??a nha s??? \'${dentist.name}\' kh???i danh s??ch?',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.center,
                                  ),
                                  okBtnText: 'X??a', okBtnFunction: () {
                                BlocProvider.of<DentistBloc>(context).add(
                                  DentistDelEventRequested(
                                      dentistId: dentist.id),
                                );
                                Navigator.of(context).pop();
                              })
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }

            if (state is ClinicStateFailure) {
              return Text('get Dentist some thing went wrong!!!');
            }

            return Center(
              child: Container(
                margin: EdgeInsets.only(top: 30),
                height: 50,
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
                child: MaterialButton(
                  padding: EdgeInsets.symmetric(horizontal: 45),
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  child: Text(
                    'L???y danh s??ch nha s???',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontFamily: 'WorkSansBold'),
                  ),
                  onPressed: () {
                    BlocProvider.of<DentistBloc>(context).add(
                      DentistEventRequested(),
                    );
                  },
                ),
              ),
            );
          },
        ),
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
