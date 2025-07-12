import 'dart:ui';
import 'package:flame/components.dart';

class ExpBar extends PositionComponent {
  final double value;

  ExpBar({
    required this.value,
  });

  // 196 * 16 outer Ae866B as border and white as bg
  // ? * 10 with padding-x 2 padding-y 1 full 8b7160 bg color

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final bgRect = Rect.fromLTWH(0, 0, 196 * 2, 16 * 2);
    final bgRRect = RRect.fromRectAndRadius(bgRect, const Radius.circular(6));
    canvas.drawRRect(bgRRect, Paint()..color = const Color(0xFFFFFFFF));

    final borderRect = Rect.fromLTWH(0, 0, 196 * 2, 16 * 2);
    final borderRRect =
        RRect.fromRectAndRadius(borderRect, const Radius.circular(6));
    canvas.drawRRect(
        borderRRect,
        Paint()
          ..color = const Color(0xFFAE866B)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2);

    final valueRect = Rect.fromLTWH(8, 6, 188 * value * 2, 10 * 2);
    final valueRRect =
        RRect.fromRectAndRadius(valueRect, const Radius.circular(4));
    canvas.drawRRect(valueRRect, Paint()..color = const Color(0xFF8B7160));
  }
}
