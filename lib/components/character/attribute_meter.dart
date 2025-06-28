import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:work_on_time_game/components/character/arrow.dart';
import 'package:work_on_time_game/config/colors.dart';
import 'package:work_on_time_game/config/typography.dart';
import 'package:work_on_time_game/painter/rounded_rect_painter.dart';

class AttributeMeter extends PositionComponent {
  final String attributeName;
  final double value;

  AttributeMeter({
    super.position,
    required this.attributeName,
    required this.value,
  });

  @override
  Future<void> onLoad() async {
    super.onLoad();

    size = Vector2(437, 78);

    // 用 canvas 畫圓邊容器
    final container = CustomPainterComponent(
      painter: RoundedRectPainter(),
      size: size,
    );
    add(container);

    // 屬性名稱文字
    final nameText = TextComponent(
      text: attributeName,
      textRenderer: TextPaint(
        style: typography.tp32.withColor(AppColors.brown500),
      ),
      position: Vector2(31, 23),
    );
    add(nameText);

    final meter = Meter(width: 258, value: value);
    meter.position = Vector2(106, 24);
    add(meter);

    // 向上箭頭
    final arrow = Arrow(
      direction: 1,
      position: Vector2(396, 25),
    );
    add(arrow);
  }
}

class Meter extends PositionComponent {
  final double width;
  final double value;

  Meter({
    required this.width,
    required this.value,
  });

  @override
  Future<void> onLoad() async {
    super.onLoad();

    size = Vector2(width, 30);

    final background = RectangleComponent(
      size: Vector2(width, 3),
      paint: Paint()..color = AppColors.brown500,
      position: Vector2(0, 30),
    );
    add(background);

    // 起點
    final indicatorStart = RectangleComponent(
      size: Vector2(2, 8),
      paint: Paint()..color = AppColors.brown500,
      position: Vector2(0, 22),
    );
    add(indicatorStart);

    // 中間
    final indicatorMiddle = RectangleComponent(
      size: Vector2(2, 20),
      paint: Paint()..color = AppColors.brown500,
      position: Vector2(width * 0.5 - 1, 10),
    );
    add(indicatorMiddle);

    // 終點
    final indicatorEnd = RectangleComponent(
      size: Vector2(2, 8),
      paint: Paint()..color = AppColors.brown500,
      position: Vector2(width - 2, 22),
    );
    add(indicatorEnd);

    // 倒三角形 （指標）
    // 31, 27
    final triangle = PolygonComponent(
      [
        Vector2(0, 0),
        Vector2(28, 0),
        Vector2(14, 22),
      ],
      size: Vector2(31, 27),
      paint: Paint()..color = AppColors.brown500,
      position: Vector2(0, 9),
    );
    triangle.position.x = width * value - 15;
    add(triangle);
  }

  @override
  void onMount() {
    super.onMount();
    debugMode = false;
  }
}
