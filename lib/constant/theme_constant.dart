import 'package:csv_json_import/constant/color_constant.dart';
import 'package:flutter/material.dart';

import 'dart:math';


ThemeData getTheme({required BuildContext context}) {
  return ThemeData(
    useMaterial3: false,
    fontFamily: "monstserrat",    
    primarySwatch: _generateMaterialColor(primaryColor),
    
  );
}



class CustomFont {
  static const boldText = TextStyle(
    fontSize: 25,
    fontFamily: 'monstserrat',
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
    color: Color(0xFF2E2E2E),
    letterSpacing: 0,
   
  );
  static const mediumText = TextStyle(
    fontSize: 25,
    fontFamily: 'monstserrat',
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
    color: Color(0xFF2E2E2E),
    letterSpacing: 0,
    height: 1.2,
  );
  static const regularText = TextStyle(
    fontSize: 15,
    fontFamily: 'monstserrat',
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    color: Color(0xFF2E2E2E),
    letterSpacing: 0,
    height: 1.2,
  );
  static const lightText = TextStyle(
    fontSize: 13,
    fontFamily: 'monstserrat',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    color: Color(0xFF2E2E2E),
    letterSpacing: 0,
  );
}

MaterialColor _generateMaterialColor(Color color) {
  return MaterialColor(color.value, {
    50: _tintColor(color, 0.9),
    100: _tintColor(color, 0.8),
    200: _tintColor(color, 0.6),
    300: _tintColor(color, 0.4),
    400: _tintColor(color, 0.2),
    500: color,
    600: _shadeColor(color, 0.1),
    700: _shadeColor(color, 0.2),
    800: _shadeColor(color, 0.3),
    900: _shadeColor(color, 0.4),
  });
}

int _tintValue(int value, double factor) =>
    max(0, min((value + ((255 - value) * factor)).round(), 255));

Color _tintColor(Color color, double factor) => Color.fromRGBO(
    _tintValue(color.red, factor),
    _tintValue(color.green, factor),
    _tintValue(color.blue, factor),
    1);

int _shadeValue(int value, double factor) =>
    max(0, min(value - (value * factor).round(), 255));

Color _shadeColor(Color color, double factor) => Color.fromRGBO(
    _shadeValue(color.red, factor),
    _shadeValue(color.green, factor),
    _shadeValue(color.blue, factor),
    1);
