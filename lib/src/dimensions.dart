import 'package:flutter/widgets.dart';

class Dimensions {
  static double? vert;
  static double? horiz;
  static double? screenWidth;
  static double? screenHeight;
  static MediaQueryData? _mediaQueryData;

  static double? width;
  static double? height;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData!.size.width;
    screenHeight = _mediaQueryData!.size.height;
    vert = screenHeight! / 100;
    horiz = screenWidth! / 100;

    height = vert! * 100;
    width = horiz! * 100;
  }
}
