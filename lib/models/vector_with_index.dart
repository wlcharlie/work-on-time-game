import 'package:flame/components.dart';

class VectorWithIndex {
  final int index;
  final Vector2 vector2;

  VectorWithIndex({
    this.index = 0,
    required double x,
    required double y,
  }) : vector2 = Vector2(x, y);
}
