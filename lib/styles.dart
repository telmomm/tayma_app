import 'package:flutter/material.dart';
import 'dart:math';

///***  COMMON   ***///
double calculateMinDimension(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;
  return min(screenWidth, screenHeight);
}
///***   BUTTONS   ***///
ButtonStyle sosButtonStyle(BuildContext context) {
  double minDimension = calculateMinDimension(context);
  return ElevatedButton.styleFrom(
    shape: CircleBorder(),
    padding: EdgeInsets.zero,
    fixedSize: Size(minDimension*0.8, minDimension*0.8),
    backgroundColor: Colors.red,
  );
}

///***   TEXT   ***///
TextStyle sosTextStyle(BuildContext context) {
  double minDimension = calculateMinDimension(context);
  return TextStyle(
    fontSize: minDimension * 0.3, // tamaño del texto
    color: Colors.white, // color del texto
  );
}

TextStyle appBarTextStyle(BuildContext context) {
  double minDimension = calculateMinDimension(context);
  return TextStyle(
    fontSize: minDimension * 0.05, // tamaño del texto
    fontWeight: FontWeight.bold, // grosor del texto
    color: Colors.white, // color del texto
  );
}

///***   ICONS   ***///
IconThemeData sosIconStyle(BuildContext context) {
  double minDimension = calculateMinDimension(context);
  return IconThemeData(
    color: Colors.white, // color del icono
    size: minDimension * 0.4, // tamaño del icono
  );
}

///***   APPBAR   ***///
PreferredSizeWidget appBarStyle(BuildContext context, String title) {
  double minDimension = calculateMinDimension(context);
  return PreferredSize(
    preferredSize: Size(minDimension * 0.08 , minDimension * 0.08), // aquí puedes cambiar la altura
    child: AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontSize: minDimension * 0.05, // tamaño del texto
          fontWeight: FontWeight.bold, // grosor del texto
          color: Colors.white, // color del texto
        ),
      ),
      //Delete menu button
      automaticallyImplyLeading: false,
    ),
  );
}