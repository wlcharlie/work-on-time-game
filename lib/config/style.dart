import 'package:flutter/material.dart';

class Style {
  static final Style _instance = Style._internal();
  factory Style() => _instance;
  Style._internal();

  BoxDecoration get defaultBoxDecoration => BoxDecoration(
        color: Color(0xF2FFFFFF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color(0xFF887768), width: 3),
      );
}

final style = Style();
