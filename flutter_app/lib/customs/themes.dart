import 'dart:ui';

import 'package:flutter/cupertino.dart';

class CustomTheme {
  const CustomTheme();

  static const Color colorStart = Color(0xFFda5c36);
  static const Color colorEnd = Color(0xFFf3a14d);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  static const LinearGradient primaryGradient = LinearGradient(
      colors: <Color>[CustomTheme.colorStart, CustomTheme.colorEnd],
      begin: FractionalOffset.topRight,
      end: FractionalOffset.bottomLeft,
      stops: <double>[0.0, 1.0],
      tileMode: TileMode.mirror);
}
