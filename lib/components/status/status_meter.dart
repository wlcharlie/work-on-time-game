import 'package:flame/components.dart';
import 'dart:ui';
import 'package:work_on_time_game/wot_game.dart';

class StatusMeter extends PositionComponent with HasGameReference<WOTGame> {
  final String iconPath;
  final Color meterColor;
  final double meterLevel; // 0.0 to 1.0 representing the fill level

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
  }) {
    this.position = position ?? Vector2.zero();
    this.size = size ?? Vector2(40, 40);

    _borderPaint = Paint()
      ..color = const Color(0xFFAE866B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    _bgPaint = Paint()..color = const Color(0xFFFFFFFF);

    _meterPaint = Paint()..color = meterColor;
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
      position: Vector2(
        size.x / 2 - _iconSprite.image.width / 2,
        size.y / 2 - _iconSprite.image.height / 2,
      ),
    );

    // Draw border
    canvas.drawRRect(bgRRect, _borderPaint);
  }
}
