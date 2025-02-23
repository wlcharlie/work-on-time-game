import 'package:flutter/material.dart';

class Typography {
  static final Typography _instance = Typography._internal();
  factory Typography() => _instance;
  Typography._internal();

  // Font weights
  static const bold = FontWeight.w700;
  static const medium = FontWeight.w500;
  static const regular = FontWeight.w400;

  TextStyle get tp20m => TextStyle(
        fontSize: 20,
        fontWeight: medium,
        fontFamily: 'TaiwanPearl',
        height: 1,
        letterSpacing: 0,
        color: Color(0xFF887768),
      );

  TextStyle get tp20 => TextStyle(
        fontSize: 20,
        fontWeight: regular,
        fontFamily: 'TaiwanPearl',
        height: 1,
        letterSpacing: 0,
        color: Color(0xFF887768),
      );
  TextStyle get tp14 => TextStyle(
        fontSize: 14,
        fontWeight: regular,
        fontFamily: 'TaiwanPearl',
        height: 1,
        letterSpacing: 0,
        color: Color(0xFF887768),
      );
}

final typography = Typography();
