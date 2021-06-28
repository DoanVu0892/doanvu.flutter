import 'package:flutter/material.dart';
import 'package:flutter_app/blocs/update_view_bloc.dart';
import 'package:flutter_app/customs/themes.dart';
import 'package:flutter_app/events/update_view_event.dart';
import 'package:flutter_app/models/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../custom_navigation_drawer.dart';

class CollapsingNavigationDrawer extends StatefulWidget {
  final User user;

  CollapsingNavigationDrawer({Key key, @required this.user})
      : assert(user != null),
        super(key: key);

  @override
  CollapsingNavigationDrawerState createState() {
    return new CollapsingNavigationDrawerState(user: user);
  }
}

class CollapsingNavigationDrawerState extends State<CollapsingNavigationDrawer>
    with SingleTickerProviderStateMixin {
  final User user;

  CollapsingNavigationDrawerState({@required this.user}) : assert(user != null);

  double maxWidth = 300;
  double minWidth = 70;
  bool isCollapsed = false;
  AnimationController _animationController;
  Animation<double> widthAnimation;
  bool isManager = false;

  @override
  void initState() {
    super.initState();
    if (user.userType == 2) {
      setState(() {
        isManager = true;
      });
    } else {
      setState(() {
        isManager = false;
      });
    }

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    widthAnimation = Tween<double>(begin: maxWidth, end: minWidth)
        .animate(_animationController);
  }

  Color _getColorWithIndex(int index) {
    switch (index) {
      case 0:
        return Colors.white;
      case 1:
        return Colors.purpleAccent;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.red;
      case 4:
        return Colors.orange;
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    Icon iconData = Icon(
      Icons.person,
      color: Colors.blue,
    );

    print('currentSelectedIndex: $currentSelectedIndex');
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, widget) => getWidget(context, widget),
    );
  }

  Widget getWidget(context, widget) {
    return Material(
      elevation: 80.0,
      child: Container(
        padding: const EdgeInsets.only(top: 38),
        width: widthAnimation.value,
        // color: drawerBackgroundColor,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: <Color>[
                CustomTheme.loginGradientStart,
                CustomTheme.loginGradientEnd
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 1.0),
              stops: <double>[0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: Column(
          children: <Widget>[
            // Center(child: CollapsingListTile(title: user.name, icon: Icons.person, animationController: _animationController,),),
            Center(
                child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin:
                      EdgeInsets.only(left: 60, top: 20, bottom: 20, right: 10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.white,
                      border: Border.all(width: 0)),
                  child: Icon(
                    Icons.person,
                    color: Colors.blue,
                  ),
                ),
                Text(
                  user.name,
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
              ],
            )),
            Divider(
              color: Colors.grey,
              height: 40.0,
            ),
            Expanded(
              child: isManager
                  ? ListView.separated(
                      separatorBuilder: (context, counter) {
                        return Divider(height: 12.0);
                      },
                      itemBuilder: (context, counter) {
                        return CollapsingListTile(
                          onTap: () {
                            setState(() {
                              currentSelectedIndex = counter;
                              selectedColor =
                                  _getColorWithIndex(currentSelectedIndex);
                              title = navigationItems[counter].title;
                            });
                            selectMenu(context, counter);
                            Navigator.of(context).pop(context);
                          },
                          isSelected: currentSelectedIndex == counter,
                          title: navigationItems[counter].title,
                          icon: navigationItems[counter].icon,
                          animationController: _animationController,
                        );
                      },
                      itemCount: navigationItems.length,
                    )
                  : ListView.separated(
                      separatorBuilder: (context, counter) {
                        return Divider(height: 12.0);
                      },
                      itemBuilder: (context, counter) {
                        return CollapsingListTile(
                          onTap: () {
                            setState(() {
                              currentSelectedIndex = counter;
                              title = navigationItems[counter].title;
                            });
                            selectMenu(context, counter);
                            print('index: $currentSelectedIndex');
                          },
                          isSelected: currentSelectedIndex == counter,
                          title: navigationItemsUser[counter].title,
                          icon: navigationItemsUser[counter].icon,
                          animationController: _animationController,
                        );
                      },
                      itemCount: navigationItemsUser.length,
                    ),
            ),
            /*InkWell(
              onTap: () {
                setState(() {
                  isCollapsed = !isCollapsed;
                  isCollapsed
                      ? _animationController.forward()
                      : _animationController.reverse();
                });
              },
              child: AnimatedIcon(
                icon: AnimatedIcons.close_menu,
                progress: _animationController,
                color: selectedColor,
                size: 50.0,
              ),
            ),
            SizedBox(
              height: 50.0,
            ),*/
          ],
        ),
      ),
    );
  }

  void selectMenu(BuildContext context, int index) {
    switch (index) {
      case 0:
        //getBranch
        if (isManager) {
          // setState(() {
          //   keyTitle = 'Branch';
          // });
          // BlocProvider.of<BranchBloc>(context)
          //     .add(BranchEventRequestedNonToken());
          BlocProvider.of<UpdateViewBloc>(context).add(
            UpdateViewChangedEvent(title: navigationItems[index].title)
          );
        } else {
          print('chua code: $index');
        }
        break;
      case 1:
        if (isManager) {
          setState(() {
            keyTitle = 'Dentist';
          });
          // BlocProvider.of<DentistBloc>(context)
          //     .add(DentistEventRequested(clinicId: '60cc71b9e13acf45a501368d'));
          BlocProvider.of<UpdateViewBloc>(context).add(
              UpdateViewChangedEvent(title: navigationItems[index].title)
          );
        } else {
          print('chua code: $index');
        }
        break;
    }
  }
}
