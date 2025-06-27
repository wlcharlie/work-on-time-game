import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/text.dart';
import 'package:flutter/painting.dart';
import 'package:work_on_time_game/config/typography.dart';

class Button extends PositionComponent {
  late Paint _bgPaint;
  late RRect _rrect;
  late String _text;

  Button({
    required super.size,
    required String text,
    Vector2? scale,
    Vector2? position,
  }) {
    this.position = position ?? Vector2.zero();
    this.scale = scale ?? Vector2.all(1);
    this._text = text;

    _rrect = RRect.fromLTRBR(
      0,
      0,
      size.x,
      size.y,
      Radius.circular(20),
    );

    final textComponent = TextBoxComponent(
      text: _text,
      align: Anchor.center,
      boxConfig: TextBoxConfig(
        margins: EdgeInsets.zero,
        maxWidth: size.x,
      ),
      textRenderer: TextPaint(
        style: typography.tp40
            .withFontWeight(FontWeight.w600)
            .withColor(Color(0xFFFFFFFF)),
      ),
    );

    textComponent.position = Vector2(0, (size.y - textComponent.size.y) / 2);

    add(textComponent);
  }

  @override
  void onLoad() {
    super.onLoad();

    _bgPaint = Paint()
      ..color = Color(0xFF907054)
      ..strokeJoin = StrokeJoin.round;
  }

  @override
  void onMount() {
    super.onMount();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRRect(_rrect, _bgPaint);
  }
}
