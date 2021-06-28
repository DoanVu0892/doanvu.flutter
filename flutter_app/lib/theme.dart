import 'package:flutter/material.dart';
import 'package:flutter_app/custom_navigation_drawer.dart';

TextStyle listTitleDefaultTextStyle = TextStyle(color: Colors.white70, fontSize: 20.0, fontWeight: FontWeight.w600);
TextStyle listTitleSelectedTextStyle = TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w600);

Color selectedColor = Color(0xFF4AC8EA);
int currentSelectedIndex = 0;
Color drawerBackgroundColor = Color(0xFF272D34);
String title = navigationItems.first.title;
String keyTitle = 'Branch';