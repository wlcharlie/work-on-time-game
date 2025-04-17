import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart' show Canvas;
import 'package:work_on_time_game/config/images.dart';
import 'package:work_on_time_game/config/typography.dart';
import 'package:work_on_time_game/wot_game.dart';

class Mirror extends PositionComponent
    with HasGameReference<WOTGame>, TapCallbacks, HasPaint {
  late EndlessScrollingBackground _bg;
  late SpriteComponent _character;
  late Dialog _dialog;

  final void Function() onTap;

  Mirror({required this.onTap});

  @override
  void onLoad() {
    super.onLoad();
    size = game.size;
    position = game.camera.viewfinder.position;
    _bg = EndlessScrollingBackground(
      image: game.images.fromCache(images.greenDotBackground),
    );
    final characterImage = game.images.fromCache(images.character);
    final characterSprite = Sprite(characterImage);
    _character = SpriteComponent(
      sprite: characterSprite,
      position: Vector2(79, 73),
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
        },
      ),
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    onTap();
  }
}

// Create a new component for an endless scrolling background
class EndlessScrollingBackground extends PositionComponent
    with HasGameReference<WOTGame>, HasPaint {
  final Vector2 speed;
  late final Sprite _sprite;
  late final Vector2 _textureSize;
  Vector2 _position = Vector2.zero();

  EndlessScrollingBackground({
    required image,
    Vector2? speed,
  }) : speed = speed ?? Vector2(30, 12) {
    _sprite = Sprite(image);
    _sprite.srcSize =
        Vector2(image.width.toDouble() - 12, image.height.toDouble() + 2);
    _textureSize = Vector2(image.width.toDouble(), image.height.toDouble());
    _sprite.paint = paint;
  }

  @override
  void onLoad() {
    super.onLoad();
    // Set this component's size to cover the entire screen
    size = game.size;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Calculate how many times we need to tile the sprite horizontally and vertically
    final horizontalTiles = (size.x / _textureSize.x).ceil() + 2;
    final verticalTiles = (size.y / _textureSize.y).ceil() + 2;

    // Calculate the offset for wrapping effect
    // NOTE: We use negative offset for x and y to make the tiles move diagonally from top-left to bottom-right
    final xOffset = -(_position.x % _textureSize.x);
    final yOffset = -(_position.y % _textureSize.y);

    // Draw the tiles with proper wrapping
    for (int y = -1; y < verticalTiles; y++) {
      for (int x = -1; x < horizontalTiles; x++) {
        final renderPosition = Vector2(
          x * _textureSize.x + xOffset,
          y * _textureSize.y + yOffset,
        );

        _sprite.render(
          canvas,
          position: renderPosition,
          size: _textureSize,
        );
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Update the position by the speed (positive values for both x and y)
    _position -= speed * dt;
  }
}

class Dialog extends PositionComponent with HasGameReference<WOTGame> {
  Dialog({required this.onTap});

  final void Function() onTap;

  @override
  void onLoad() {
    super.onLoad();
    size = Vector2(345, 68);
    position = Vector2(24, 755);
    anchor = Anchor.topLeft;

    // text
    final text = TextBoxComponent(
        text: "今天的裝扮感覺很不錯！",
        textRenderer: TextPaint(
          style: typography.tp20,
        ),
        align: Anchor.center,
        anchor: Anchor.center,
        position: Vector2(size.x / 2, size.y / 2),
        boxConfig: TextBoxConfig(
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
