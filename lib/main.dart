import 'package:flutter/material.dart';
import 'package:nber_flutter/TRansPortFIle.dart';
import 'SplashScreen.dart';
import 'Login.dart';
import 'NavigationHomeScreen.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Login());
   // return MaterialApp(home: TransPortFile());
  }
}
class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}