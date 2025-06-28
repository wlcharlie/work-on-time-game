import 'package:flame/components.dart';
import 'dart:ui';
import 'package:flutter/painting.dart';
import 'package:work_on_time_game/config/colors.dart';
import 'package:work_on_time_game/config/typography.dart';
import 'package:work_on_time_game/wot_game.dart';
import 'package:work_on_time_game/components/character/arrow.dart';

class Attribute extends PositionComponent with HasGameReference<WOTGame> {
  final String text;
  final Color textColor;
  final int? deltaDirection; // -1, 1

  late final TextPaint _textPaint;
  Arrow? _arrow;

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

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Add arrow if deltaDirection is specified
    if (deltaDirection != null) {
      _arrow = Arrow(
        direction: deltaDirection!,
        position: Vector2(size.x + 1, size.y / 2 - 12),
      );
      add(_arrow!);
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Draw text
    final textPainter = _textPaint.toTextPainter(text);
    textPainter.layout();
    textPainter.paint(canvas, Offset.zero);
  }
}
