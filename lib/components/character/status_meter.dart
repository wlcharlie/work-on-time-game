import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:work_on_time_game/config/colors.dart';
import 'dart:ui';
import 'package:work_on_time_game/wot_game.dart';

class StatusMeter extends PositionComponent with HasGameReference<WOTGame> {
  final String iconPath;
  final Color meterColor;
  final double meterLevel; // 0.0 to 1.0 representing the fill level
  final int? deltaDirection; // -1, 1

  late final Sprite _iconSprite;
  late final Paint _borderPaint;
  late final Paint _bgPaint;
  late final Paint _meterPaint;

  StatusMeter({
    required this.iconPath,
    required this.meterColor,
    this.meterLevel = 0.5, // Default to half full
    Vector2? position,
    Vector2? size,
    this.deltaDirection, // -1, 1
  }) {
    this.position = position ?? Vector2.zero();
    this.size = size ?? Vector2(40, 40);

    _borderPaint = Paint()
      ..color = AppColors.brown500
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    _bgPaint = Paint()..color = const Color(0xFFFFFFFF);

    _meterPaint = Paint()..color = meterColor;
  }

  void _drawUpwardArrow(Canvas canvas) {
    final arrowX = size.x + 16;
    final arrowY = size.y / 2;

    final arrowPlankPaint = Paint()
      ..color = AppColors.brown500
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final arrowWingPaint = Paint()
      ..color = AppColors.brown500
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    // ..strokeCap = StrokeCap.round;

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
  Future<void> onLoad() async {
    super.onLoad();
    if (!game.images.containsKey(iconPath)) {
      await game.images.load(iconPath);
    }
    final image = game.images.fromCache(iconPath);

    _iconSprite = Sprite(image);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Draw background (white)
    final bgRect = Rect.fromLTWH(0, 0, size.x, size.y);
    final bgRRect = RRect.fromRectAndRadius(bgRect, const Radius.circular(6));
    canvas.drawRRect(bgRRect, _bgPaint);

    // Draw meter at the bottom part
    final meterHeight = size.y * meterLevel; // Half of the height * level
    final meterRect =
        Rect.fromLTWH(0, size.y - meterHeight, size.x, meterHeight);
    final meterRRect = RRect.fromRectAndCorners(
      meterRect,
      bottomLeft: const Radius.circular(4),
      bottomRight: const Radius.circular(4),
    );
    canvas.drawRRect(meterRRect, _meterPaint);

    // Draw icon on top
    _iconSprite.render(
      canvas,
      anchor: Anchor.center,
      size: Vector2(
        size.x / 1.5,
        (size.y / 1.5) * _iconSprite.image.height / _iconSprite.image.width,
      ),
      position: Vector2(
        size.x / 2,
        size.y / 2,
      ),
    );

    // _drawUpwardArrow(canvas);

    // Draw arrow based on deltaDirection
    if (deltaDirection == 1) {
      _drawUpwardArrow(canvas);
    } else if (deltaDirection == -1) {
      canvas.save();
      final arrowX = size.x + 16;
      final arrowY = size.y / 2;
      canvas.translate(arrowX, arrowY);
      canvas.rotate(3.14159); // 180 degrees in radians (π)
      canvas.translate(-arrowX, -arrowY);
      _drawUpwardArrow(canvas);
      canvas.restore();
    }

    // Draw border
    canvas.drawRRect(bgRRect, _borderPaint);
  }
}
