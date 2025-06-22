import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:work_on_time_game/config/images.dart';

class Penguin extends SpriteComponent {
  late final bool withHitbox;

  PolygonHitbox? _hitbox;

  Penguin({this.withHitbox = true});

  @override
  Future<void> onLoad() async {
    super.onLoad();
    final image = await Flame.images.load(images.penguin);
    sprite = Sprite(image);

    if (withHitbox) {
      _updateHitbox();
    }
  }

  @override
  void onMount() {
    super.onMount();
    final ratio = sprite!.src.width / sprite!.src.height;
    size = Vector2(size.x, size.x / ratio);
  }

  void _updateHitbox() {
    // Remove existing hitbox if any
    _hitbox?.removeFromParent();

    final topLeft = Vector2(20, 80);
    final topRight = Vector2(size.x, 80);
    final bottomLeft = Vector2(20, 450);
    final bottomRight = Vector2(size.x, 450);

    _hitbox = PolygonHitbox([
      topLeft,
      topRight,
      bottomRight,
      bottomLeft,
    ])
      ..debugColor = Color(0xFF000000)
      ..collisionType = CollisionType.passive;

    add(_hitbox!);
  }
}
