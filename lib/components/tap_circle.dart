import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';

class TapCircleEffect extends PositionComponent with TapCallbacks {
  TapCircleEffect();

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size = size;
    anchor = Anchor.topLeft;
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    add(TapCircle(center: event.localPosition));
  }
}

class TapCircle extends PositionComponent {
  TapCircle({required this.center});

  final Color color = Color(0xFFFFFFFF);
  final Vector2 center;
  late final _paint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2
    ..color = color;

  double _radius = 0;

  static const double _maxRadius = 12;
  static const double _speed = 30;

  @override
  void onLoad() {
    super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawCircle(center.toOffset(), _radius, _paint);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_radius <= _maxRadius) {
      _radius += dt * _speed;
      // 漸漸變淡
      _paint.color =
          Color.lerp(color, color.withValues(alpha: 0), _radius / _maxRadius)!;
    }

    if (_radius >= _maxRadius) {
      _paint.color = color.withValues(alpha: 0);
      removeFromParent();
    }
  }
}
