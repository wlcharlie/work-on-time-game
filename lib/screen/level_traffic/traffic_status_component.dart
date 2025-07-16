import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:work_on_time_game/config/images.dart';
import 'package:work_on_time_game/wot_game.dart';

class TrafficStatusComponent extends PositionComponent
    with HasGameReference<WOTGame>, RiverpodComponentMixin {
  late final TextComponent _statusText;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // 建立狀態文字
    _statusText = TextComponent(
      text: '狀態',
      position: Vector2(
        game.size.x / 2,
        50,
      ),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFF000000),
          fontSize: 24,
        ),
      ),
    );
    add(_statusText);
  }

  void updateStatus(String status) {
    _statusText.text = status;
  }
}

class ProgressBarComponent extends PositionComponent {
  double _progress;
  final Color backgroundColor;
  final Color progressColor;

  ProgressBarComponent({
    required Vector2 size,
    required Vector2 position,
    required double progress,
    required this.backgroundColor,
    required this.progressColor,
  })  : _progress = progress,
        super(size: size, position: position);

  void setProgress(double value) {
    _progress = value.clamp(0.0, 1.0);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // 繪製背景
    final bgPaint = Paint()..color = backgroundColor;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      bgPaint,
    );

    // 繪製進度
    final progressPaint = Paint()..color = progressColor;
    canvas.drawRect(
      Rect.fromLTWH(0, size.y * (1 - _progress), size.x, size.y * _progress),
      progressPaint,
    );
  }
}
