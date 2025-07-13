import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart' show Canvas;
import 'package:work_on_time_game/components/background/endless_background.dart';
import 'package:work_on_time_game/config/images.dart';
import 'package:work_on_time_game/config/typography.dart';
import 'package:work_on_time_game/wot_game.dart';

class MirrorView extends PositionComponent
    with HasGameReference<WOTGame>, TapCallbacks, HasPaint {
  late EndlessBackground _bg;
  late SpriteComponent _character;
  late Dialog _dialog;

  bool canInteract = false;

  final void Function() onTap;

  MirrorView({required this.onTap});

  @override
  void onLoad() {
    super.onLoad();
    game.isPannable = false;
    size = game.size;
    position = game.camera.viewfinder.position;
    _bg = EndlessBackground(
      image: game.images.fromCache(images.greenDotBackground),
    );
    final characterImage = game.images.fromCache(images.character);
    final characterSprite = Sprite(characterImage);
    _character = SpriteComponent(
      sprite: characterSprite,
      position: Vector2(79, 73) * 2,
    );

    _dialog = Dialog(onTap: () {});

    _bg.makeTransparent();
    _character.makeTransparent();

    add(_bg);
    add(_character);
    _bg.add(
      OpacityEffect.to(
        1,
        EffectController(duration: 0.8),
      ),
    );
    _character.add(
      OpacityEffect.to(
        1,
        EffectController(duration: 0.8, startDelay: 0.8),
        onComplete: () {
          add(_dialog);

          Future.delayed(const Duration(milliseconds: 500), () {
            canInteract = true;
          });
        },
      ),
    );
  }

  @override
  void onRemove() {
    game.isPannable = true;
    super.onRemove();
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    if (!canInteract) return;
    onTap();
  }
}

class Dialog extends PositionComponent with HasGameReference<WOTGame> {
  Dialog({required this.onTap});

  final void Function() onTap;

  @override
  void onLoad() {
    super.onLoad();
    size = Vector2(690, 136);
    position = Vector2(48, 1510);
    anchor = Anchor.topLeft;

    // text
    final text = TextBoxComponent(
        text: "今天的裝扮感覺很不錯！",
        textRenderer: TextPaint(
          style: typography.tp40,
        ),
        align: Anchor.center,
        anchor: Anchor.center,
        position: Vector2(size.x / 2, size.y / 2),
        boxConfig: TextBoxConfig(
          maxWidth: 690,
          timePerChar: 0.05,
        ));
    add(text);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // bgfill
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.x, size.y),
        Radius.circular(10),
      ),
      Paint()
        ..color =
            ColorExtension.fromRGBHexString("#FFFFFF").withValues(alpha: 0.8),
    );

    // border
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.x, size.y),
        Radius.circular(10),
      ),
      Paint()
        ..color = ColorExtension.fromRGBHexString("#887768")
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
  }
}
