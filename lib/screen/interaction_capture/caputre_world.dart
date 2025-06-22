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
import 'package:work_on_time_game/components/photo_instax.dart';
import 'package:work_on_time_game/config/images.dart';
import 'package:work_on_time_game/extension/position.dart';
import 'package:work_on_time_game/wot_game.dart';

class SnapshotComponent extends PositionComponent
    with HasGameReference<WOTGame>, Snapshot {
  SnapshotComponent() {
    renderSnapshot = false;
  }
}

class FlashEffect extends RectangleComponent with HasGameReference<WOTGame> {
  late final VoidCallback onComplete;

  FlashEffect({required this.onComplete}) {
    position = Vector2.zero();
    paint = Paint()..color = const Color(0xFFFFFFFF);
    opacity = 1.0;
  }

  @override
  void onMount() {
    super.onMount();

    size = game.size;

    add(
      SequenceEffect(
        [
          OpacityEffect.to(
              0.0, EffectController(duration: 2.0, startDelay: 0.5)),
          RemoveEffect(),
        ],
        onComplete: onComplete,
      ),
    );
  }
}

class InteractionCaptureWorld extends World
    with HasGameReference<WOTGame>, HasCollisionDetection, TapCallbacks {
  late final SnapshotComponent _snapshotComponent;

  late final EndlessBackground _bg;
  late final FramingCrosshair _framingCrosshair;
  late final SpriteComponent _movingPenguin;

  late final TimerComponent _penguinRandomPositionTimerComponent;
  Vector2 _penguinNextRandomPosition = Vector2(0, 0);

  // state
  bool _canCapture = true;

  void _updatePenguinRandomPosition() {
    // Generate new random position

    _penguinNextRandomPosition = Vector2(
      -150 + (600) * Random().nextDouble(),
      -150 + (600) * Random().nextDouble(),
    );

    // Create a MoveToEffect that takes exactly 2 seconds
    final moveEffect = MoveToEffect(
      _penguinNextRandomPosition,
      EffectController(duration: 2.0, curve: Curves.easeOut),
    );

    // Remove any existing move effects and add the new one
    _movingPenguin.removeWhere((component) => component is MoveToEffect);
    _movingPenguin.add(moveEffect);
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    final image = await game.images.load(images.greenDotBackground);

    _bg = EndlessBackground(image: image);
    _framingCrosshair = FramingCrosshair();

    _movingPenguin = Penguin();

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

    _movingPenguin.position = Vector2(0, 0);
    _movingPenguin.anchor = Anchor.center;

    _snapshotComponent = SnapshotComponent()
      ..size = Vector2(300, 300)
      ..position = Vector2(game.size.x / 2 - 150, game.size.y / 2 - 150)
      ..add(_movingPenguin);
    add(_bg);
    add(_snapshotComponent);
    add(_penguinRandomPositionTimerComponent);
    add(_framingCrosshair);
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);

    if (!_canCapture) return;
    _canCapture = false;

    _snapshotComponent.takeSnapshot();

    final image = _snapshotComponent.snapshotAsImage(
      300, // width
      300, // height
    );

    final imageContainer = RectangleComponent();
    // white bg
    imageContainer.paint = Paint()..color = const Color(0xFFFFFFFF);
    imageContainer.size = Vector2(300, 300);
    final imageComponent = SpriteComponent.fromImage(image);
    imageContainer.add(imageComponent);
    imageContainer.position = Vector2(100, 1200);

    add(imageContainer);

    // remove 拍照元素
    remove(_framingCrosshair);
    remove(_snapshotComponent);
    remove(_penguinRandomPositionTimerComponent);

    // 閃白
    add(
      FlashEffect(
        onComplete: () {
          // 拍照完成

          final photoInstax = PhotoInstax(
              subjectBuilder: (size) =>
                  Penguin(withHitbox: false)..size = size);
          photoInstax.anchor = Anchor.topLeft;
          photoInstax.position = Vector2(60, 243);
          add(photoInstax);
        },
      ),
    );
  }
}
