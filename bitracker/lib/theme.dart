import 'package:flutter/material.dart';

const mainAccentColor = Color.fromARGB(255, 135, 255, 124);
const paleAccentColor = Color(0xffBFC6FA);
const subAccentColor = Color.fromARGB(255, 161, 255, 173);
const red900 = Color(0xffFF402F);
const red600 = Color(0xffFF6450);
const gray900 = Color(0xff1B1D1F);
const gray600 = Color(0xff454C53);
const gray400 = Color(0xff878EA1);
const gray200 = Color(0xffC9CDD2);
const gray100 = Color(0xffE8EBED);
const background = Color(0xffEDF3FB);

ColorScheme appColorScheme() {
  return const ColorScheme(
    brightness: Brightness.light,
    primary: Color.fromARGB(255, 66, 0, 0),
    onPrimary: Color.fromARGB(255, 128, 255, 121),
    secondary: Color.fromARGB(255, 111, 252, 104),
    onSecondary: Color.fromARGB(255, 255, 107, 107),
    surface: Color.fromARGB(255, 255, 255, 255),
    onSurface: Color.fromARGB(255, 255, 255, 255),
    outline: Color.fromARGB(255, 230, 230, 230),
    error: red900,
    onError: red900,
  );
}
