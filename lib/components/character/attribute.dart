import 'package:flame/components.dart';
import 'dart:ui';
import 'package:flutter/painting.dart';
import 'package:work_on_time_game/config/colors.dart';
import 'package:work_on_time_game/config/typography.dart';
import 'package:work_on_time_game/wot_game.dart';

class Attribute extends PositionComponent with HasGameReference<WOTGame> {
  final String text;
  final Color textColor;
  final int? deltaDirection; // -1, 1

  late final TextPaint _textPaint;

  Attribute({
    required this.text,
    this.textColor = AppColors.brown500,
    Vector2? position,
    Vector2? size,
    this.deltaDirection, // -1, 1
  }) {
    this.position = position ?? Vector2.zero();
    this.size = size ?? Vector2(64, 32);

    _textPaint = TextPaint(
      style: typography.tp32.withColor(textColor),
    );
  }

  void _drawUpwardArrow(Canvas canvas) {
    final arrowX = size.x + 16;
    final arrowY = size.y / 2;

    final arrowPlankPaint = Paint()
      ..color = AppColors.brown500
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final arrowWingPaint = Paint()
      ..color = AppColors.brown500
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    // ..strokeCap = StrokeCap.round;

    // 1. 繪製 Chevron 的左邊線
    canvas.drawLine(
      Offset(arrowX - 7, arrowY - 2), // 左端點
      Offset(arrowX, arrowY - 12), // 頂點
      arrowWingPaint,
    );

    // 2. 繪製 Chevron 的右邊線
    canvas.drawLine(
      Offset(arrowX, arrowY - 12), // 頂點
      Offset(arrowX + 7, arrowY - 2), // 右端點
      arrowWingPaint,
    );

    // 3. 繪製垂直橫杠
    canvas.drawLine(
      Offset(arrowX, arrowY - 12), // 橫杠頂端
      Offset(arrowX, arrowY + 12), // 橫杠底端
      arrowPlankPaint,
    );
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Draw text
    final textPainter = _textPaint.toTextPainter(text);
    textPainter.layout();
    textPainter.paint(canvas, Offset.zero);

    // Draw arrow based on deltaDirection
    if (deltaDirection == 1) {
      _drawUpwardArrow(canvas);
    } else if (deltaDirection == -1) {
      canvas.save();
      final arrowX = size.x + 8;
      final arrowY = size.y / 2;
      canvas.translate(arrowX, arrowY);
      canvas.rotate(3.14159); // 180 degrees
      canvas.translate(-arrowX, -arrowY);
      _drawUpwardArrow(canvas);
      canvas.restore();
    }
  }
}
