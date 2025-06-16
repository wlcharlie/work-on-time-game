import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:work_on_time_game/config/images.dart';

class Penguin extends SpriteComponent {
  @override
  Future<void> onLoad() async {
    super.onLoad();

    final image = await Flame.images.load(images.penguin);
    sprite = Sprite(image);

    final topLeft = Vector2(20, 80);
    final topRight = Vector2(image.width.toDouble(), 80);
    final bottomLeft = Vector2(20, 450);
    final bottomRight = Vector2(image.width.toDouble(), 450);

    add(PolygonHitbox([
      topLeft,
      topRight,
      bottomRight,
      bottomLeft,
    ])
      ..debugColor = Color(0xFF000000)
      ..collisionType = CollisionType.passive);
  }
}
