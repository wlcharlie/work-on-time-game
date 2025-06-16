import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:work_on_time_game/components/animal/penguin.dart';
import 'package:work_on_time_game/components/background/endless_background.dart';
import 'package:work_on_time_game/components/camera/framing_crosshair.dart';
import 'package:work_on_time_game/config/images.dart';
import 'package:work_on_time_game/wot_game.dart';

class InteractionCaptureWorld extends World
    with HasGameReference<WOTGame>, HasCollisionDetection {
  late final EndlessBackground _bg;
  late final FramingCrosshair _framingCrosshair;
  late final SpriteComponent _penguin;

  late final TimerComponent _penguinRandomPositionTimerComponent;
  Vector2 _penguinNextRandomPosition = Vector2(106, 791);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    final image = await game.images.load(images.greenDotBackground);

    _bg = EndlessBackground(image: image);
    _framingCrosshair = FramingCrosshair();

    _penguin = Penguin();

    _penguinRandomPositionTimerComponent = TimerComponent(
      period: 2,
      onTick: _updatePenguinRandomPosition,
      repeat: true,
    );
  }

  @override
  void onMount() {
    super.onMount();
    game.camera.viewfinder.anchor = Anchor.topLeft;
    game.camera.viewfinder.zoom = 1;

    _penguin.position = Vector2(106, 791);

    add(_bg);
    add(_penguin);
    add(_penguinRandomPositionTimerComponent);
    add(_framingCrosshair);
  }

  @override
  void onRemove() {
    super.onRemove();
  }

  void update(double dt) {
    super.update(dt);
  }

  void _updatePenguinRandomPosition() {
    // Generate new random position
    _penguinNextRandomPosition = Vector2(
      game.size.x * Random().nextDouble(),
      game.size.y * Random().nextDouble(),
    );

    // Create a MoveToEffect that takes exactly 2 seconds
    final moveEffect = MoveToEffect(
      _penguinNextRandomPosition,
      EffectController(duration: 2.0, curve: Curves.easeOut),
    );

    // Remove any existing move effects and add the new one
    _penguin.removeWhere((component) => component is MoveToEffect);
    _penguin.add(moveEffect);
  }
}
