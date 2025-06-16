// Create a new component for an endless scrolling background
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:work_on_time_game/wot_game.dart';

class EndlessBackground extends PositionComponent
    with HasGameReference<WOTGame>, HasPaint {
  final Vector2 speed;
  late final Sprite _sprite;
  late final Vector2 _textureSize;
  Vector2 _position = Vector2.zero();

  EndlessBackground({
    required Image image,
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
