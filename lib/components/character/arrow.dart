import 'package:flame/components.dart';
import 'dart:ui';
import 'package:work_on_time_game/config/colors.dart';

class Arrow extends PositionComponent {
  final int direction; // 1 for up, -1 for down

  Arrow({
    required this.direction,
    Vector2? position,
  }) {
    this.position = position ?? Vector2.zero();
    size = Vector2(14, 24); // Width and height for the arrow
  }

  void _drawUpwardArrow(Canvas canvas) {
    final arrowX = 7.0; // Center of arrow width
    final arrowY = 12.0; // Center of arrow height

    final arrowPlankPaint = Paint()
      ..color = AppColors.brown500
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final arrowWingPaint = Paint()
      ..color = AppColors.brown500
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // 1. 繪製 Chevron 的左邊線
    canvas.drawLine(
      Offset(arrowX - 7, arrowY - 2), // 左端點
      Offset(arrowX, arrowY - 12), // 頂點
      arrowWingPaint,
    );

    // 2. 繪製 Chevron 的右邊線
    canvas.drawLine(
      Offset(arrowX, arrowY - 12), // 頂點
      Offset(arrowX + 7, arrowY - 2), // 右端點
      arrowWingPaint,
    );

    // 3. 繪製垂直橫杠
    canvas.drawLine(
      Offset(arrowX, arrowY - 12), // 橫杠頂端
      Offset(arrowX, arrowY + 12), // 橫杠底端
      arrowPlankPaint,
    );
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (direction == 1) {
      _drawUpwardArrow(canvas);
    } else if (direction == -1) {
      canvas.save();
      final arrowX = 7.0;
      final arrowY = 12.0;
      canvas.translate(arrowX, arrowY);
      canvas.rotate(3.14159); // 180 degrees in radians (π)
      canvas.translate(-arrowX, -arrowY);
      _drawUpwardArrow(canvas);
      canvas.restore();
    }
  }
}
