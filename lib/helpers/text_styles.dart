import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class TextStyles {

  TextStyle getStyle(int type) {
    Color color= Colors.black;
    double fontSize= 16;
    FontWeight fontWeight= FontWeight.normal;
    TextDecoration? textDecoration;
    switch(type) {
      case 1: {
        color= Colors.black;
        fontSize= 14;
      }
      case 2: {
        color= Colors.white;
        fontSize= 16;
      }
      case 3: {
        color= Colors.black;
        fontSize= 25;
      }
      case 4: {
        color= Colors.black;
        fontSize= 20;
        fontWeight= FontWeight.bold;
      }
      case 5: {
        color= const Color.fromARGB(255, 24, 64, 97);
        fontSize= 17;
      }
      case 6: {
        color= const Color.fromARGB(255, 13, 44, 14);
        fontSize= 19;
        fontWeight= FontWeight.bold;
      }
      case 7: {
        color= Colors.white;
        fontSize= 20;
      }
      case 8: {
        color= Colors.black;
        fontSize= 20;
      }
      default: {
        color= Colors.black;
        fontSize= 14;
      }
    }
    return GoogleFonts.dosis(
      textStyle: TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        decoration: textDecoration,
        decorationThickness: 1.2,
      )
    );
  }
}