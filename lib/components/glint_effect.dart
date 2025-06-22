import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:work_on_time_game/wot_game.dart';

class GlintEffect extends Component with HasGameReference<WOTGame> {
  late final RRect clipRect;

  GlintEffect({required this.clipRect});

  @override
  void onLoad() {
    super.onLoad();

    final startPos = Vector2(clipRect.width + 50, clipRect.height + 50);
    final endPos = Vector2(-50, -50);
    final lineAngle = -atan2(clipRect.height, clipRect.width);
    final lineLength = sqrt(
        clipRect.width * clipRect.width + clipRect.height * clipRect.height);

    // 白線1
    final whiteLine1 = RectangleComponent(
      size: Vector2(lineLength, 40),
      paint: Paint()..color = const Color.fromRGBO(255, 255, 255, 0.9),
      position: startPos,
      angle: lineAngle,
      anchor: Anchor.center,
    );

    // 白線2
    final whiteLine2 = RectangleComponent(
      size: Vector2(lineLength, 40),
      paint: Paint()..color = const Color.fromRGBO(255, 255, 255, 0.9),
      position: startPos,
      angle: lineAngle,
      anchor: Anchor.center,
    );

    // 白線3
    final whiteLine3 = RectangleComponent(
      size: Vector2(lineLength, 40),
      paint: Paint()..color = const Color.fromRGBO(255, 255, 255, 0.9),
      position: startPos,
      angle: lineAngle,
      anchor: Anchor.center,
    );

    add(whiteLine1);
    add(whiteLine2);
    add(whiteLine3);

    final duration = 1.5;
    final startDelays = [0.3, 0.5, 0.52];
    final maxScales = [6.0, 1.3, 1.1];

    // 给所有线添加动画
    for (final (index, line) in [whiteLine1, whiteLine2, whiteLine3].indexed) {
      // 移动动画
      line.add(
        MoveToEffect(
          endPos,
          EffectController(
            duration: duration,
            curve: Curves.easeInOutExpo,
            startDelay: startDelays[index],
          ),
          onComplete: () {
            RemoveEffect();
          },
        ),
      );

      // 寬度動畫
      line.add(
        SequenceEffect([
          ScaleEffect.to(
            Vector2(1.0, maxScales[index]),
            EffectController(
              duration: duration / 2,
              curve: Curves.easeInExpo,
              startDelay: startDelays[index],
            ),
          ),
          ScaleEffect.to(
            Vector2(1.0, 1.0),
            EffectController(
              duration: duration / 2,
              curve: Curves.easeOutExpo,
            ),
          ),
        ]),
      );
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }
}
