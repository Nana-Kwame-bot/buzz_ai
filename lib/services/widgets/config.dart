import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const kPrimaryColor = Color.fromRGBO(230, 10, 9, 3);
const kBackgroundColor = Color(0xFFFFFFFF);
const kErrorColor = Color(0xFFFE5350);
const containerColor = Color.fromRGBO(0, 0, 0, 0.1);
const AppBarColor = Color.fromRGBO(255, 251, 254, 1);
const defaultColor = Color(0xff5247C5);
const accentColor = Color(0xFFF79D34);
const apiKey = 'AIzaSyAQEAKU4g6prYDWSpLkxNS3ECvTmUXWnu0';

class Config {
  static MediaQueryData? _mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;
  static Orientation? orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData!.size.width;
    screenHeight = _mediaQueryData!.size.height;
    orientation = _mediaQueryData!.orientation;
  }
}

class TextWidgetStyle {
  static Widget Monterserrat(
      {String? text, var color, double? size, var fontwight}) {
    return Text(
      text!,
      style: TextStyle(
          color: color,
          fontSize: size,
          fontWeight: fontwight,
          fontFamily: GoogleFonts.montserrat().fontFamily),
    );
  }

  static Widget Roboto({String? text, var color, double? size, var fontwight}) {
    return Text(
      text!,
      style: TextStyle(
          color: color,
          fontSize: size,
          fontWeight: fontwight,
          fontFamily: GoogleFonts.roboto().fontFamily),
    );
  }

  static Widget Barlow({String? text, var color, double? size, var fontwight}) {
    return Text(
      text!,
      style: TextStyle(
          color: color,
          fontSize: size,
          fontWeight: fontwight,
          fontFamily: GoogleFonts.barlow().fontFamily),
    );
  }
}
