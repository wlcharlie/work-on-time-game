import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/animation.dart';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:work_on_time_game/components/animal/penguin.dart';
import 'package:work_on_time_game/components/background/endless_background.dart';
import 'package:work_on_time_game/components/camera/framing_crosshair.dart';
import 'package:work_on_time_game/config/images.dart';
import 'package:work_on_time_game/wot_game.dart';

class SnapshotComponent extends PositionComponent
    with HasGameReference<WOTGame>, Snapshot {
  SnapshotComponent() {
    renderSnapshot = false;
  }

  @override
  FutureOr<void> onLoad() {
    super.onLoad();
    size = Vector2(game.size.x, game.size.y);
    position = Vector2(0, 0);
  }
}

class InteractionCaptureWorld extends World
    with HasGameReference<WOTGame>, HasCollisionDetection, TapCallbacks {
  late final SnapshotComponent _snapshotComponent;

  late final EndlessBackground _bg;
  late final FramingCrosshair _framingCrosshair;
  late final SpriteComponent _penguin;

  late final TimerComponent _penguinRandomPositionTimerComponent;
  Vector2 _penguinNextRandomPosition = Vector2(106, 791);

  void _updatePenguinRandomPosition() {
    // Generate new random position
    _penguinNextRandomPosition = Vector2(
      100 + (game.size.x - 200) * Random().nextDouble(),
      150 + (game.size.y - 300) * Random().nextDouble(),
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

    _penguin.position = Vector2(0, 0);
    _penguin.anchor = Anchor.center;

    _snapshotComponent = SnapshotComponent()..add(_penguin);
    add(_bg);
    add(_snapshotComponent);
    // add(_penguin);
    add(_penguinRandomPositionTimerComponent);
    add(_framingCrosshair);
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    _snapshotComponent.takeSnapshot();

    // Calculate center position for 300x300 crop
    final centerX = (game.size.x - 300) / 2;
    final centerY = (game.size.y - 300) / 2;

    // Create transform matrix to translate the snapshot
    final transform = Matrix4.identity()..translate(-centerX, -centerY);

    final image = _snapshotComponent.snapshotAsImage(
      300, // width
      300, // height
      transform: transform,
    );

    final imageContainer = RectangleComponent();
    // white bg
    imageContainer.paint = Paint()..color = const Color(0xFFFFFFFF);
    imageContainer.size = Vector2(300, 300);
    final imageComponent = SpriteComponent.fromImage(image);
    imageContainer.add(imageComponent);
    imageContainer.position = Vector2(100, 1200);

    add(imageContainer);
  }
}
