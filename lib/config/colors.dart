import 'package:flutter/material.dart';

/// Traffic-specific colors for the traffic game board
class TrafficColors {
  static const Color background = Color(0xFF515151);
  static const Color border = Color(0xFF828282);
  static const Color lucky = Color(0xFFBDD89C);
  static const Color card = Color(0xFFAACFCF);
  static const Color coffee = Color(0xFFBDD89C);
  static const Color question = Color(0xFFE9D686);
  static const Color home = Color(0xFFFC7B64);
  static const Color fallback = Color(0xFFAACFCF);

  // 新增底部與提示區塊顏色
  static const Color bottomBar = Color(0xFF8B7158);
  static const Color tipBg = Color(0xFFFFFFFF);
  static const Color tipBorder = Color(0xFFAE866B);
  static const Color tipText = Color(0xFF8B7158);
  static const Color tipIcon = Color(0xFF8B7158);

  // 骰子點顏色
  static const Color diceDotMain = Color(0xFFFC7B64); // 主色
  static const Color diceDotSub = Color(0xFF525252); // 副色
}

/// Main app colors organized by category
class AppColors {
  // Brown colors
  /// #BE936B
  static const Color brown300 = Color(0xFFBE936B);

  /// #A9886C
  static const Color brown400 = Color(0xFFA9886C);

  /// #907054
  static const Color brown500 = Color(0xFF907054);

  /// #887768
  static const Color brown600 = Color(0xFF887768);

  /// #644C3B
  static const Color brown700 = Color(0xFF644C3B);

  /// #A9886C - Same as brown400, used for borders
  static const Color borderBrown = Color(0xFFA9886C);

  // Text colors
  /// #525252 - Text color 400
  static const Color textColor400 = Color(0xFF525252);

  /// #3B3B3B - Text color 500
  static const Color textColor500 = Color(0xFF3B3B3B);

  // Grey colors
  /// #E7E7E7
  static const Color grey200 = Color(0xFFE7E7E7);

  /// #9F9F9F
  static const Color grey300 = Color(0xFF9F9F9F);

  // Pale colors
  /// #F7F2ED
  static const Color pale300 = Color(0xFFF7F2ED);

  /// #F4EBE3
  static const Color pale400 = Color(0xFFF4EBE3);

  /// #E1C4AB
  static const Color pale500 = Color(0xFFE1C4AB);

  // Accent colors
  /// #BDD89C
  static const Color green400 = Color(0xFFBDD89C);

  /// #92C05F
  static const Color green500 = Color(0xFF92C05F);

  /// #AACFCF
  static const Color blue400 = Color(0xFFAACFCF);

  /// #E9D686
  static const Color yellow400 = Color(0xFFE9D686);

  /// #FC7B64
  static const Color orange400 = Color(0xFFFC7B64);

  // Modal colors
  /// #F4E9D6
  static const Color modalContentColor = Color(0xFFF4E9D6);

  /// #AE866B
  static const Color modalContentBorder = Color(0xFFAE866B);

  // Other colors
  /// #FFFFFF
  static const Color white = Color(0xFFFFFFFF);

  /// #F6F6F6
  static const Color white2 = Color(0xFFF6F6F6);

  /// #000000 with 80% opacity
  static const Color blackOpacity80 = Color(0xCC000000);

  /// #F4F1EE
  static const Color outlineBgClick = Color(0xFFF4F1EE);
}
